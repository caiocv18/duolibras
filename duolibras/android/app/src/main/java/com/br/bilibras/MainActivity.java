package com.br.bilibras;

import android.graphics.Bitmap;
import android.graphics.Matrix;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Date;
import java.util.List;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    // Set a name for the method chanel.
    // This name is a key for the Flutter MethodChannel and needs to be equal to the name configured at the dart part
    private static final String CHANNEL = "tomer.blecher.yuv_transform/yuv";
    private long total_conversion = 0;
    private long total_rotation = 0;
    private long total_jpeg = 0;
    private long total_calls = 0;
    private YuvConverter yuvConverter;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    protected void onDestroy() {
        yuvConverter.close();
        super.onDestroy();
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        System.out.println("JAVA REGISTERED ");
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            switch (call.method) {
                                case "yuv_transform": {
                                    List<byte[]> bytesList = call.argument("platforms");
                                    int[] strides = call.argument("strides");
                                    int width = call.argument("width");
                                    int height = call.argument("height");

                                    if (total_calls == 0) {
                                        Log.w("flutter ", "row   strides " + strides[0] + ", " + strides[2] + ", " + strides[4]);
                                        Log.w("flutter ", "pixel strides " + strides[1] + ", " + strides[3] + ", " + strides[5]);
                                        Log.w("flutter ", "plane 0 " + bytesList.get(0).length + " " + strides[0] * height);
                                        Log.w("flutter ", "plane 1 " + bytesList.get(1).length + " " + strides[2] * height/2);
                                        Log.w("flutter ", "plane 2 " + bytesList.get(2).length + " " + strides[4] * height/2);

                                        long start = new Date().getTime();
                                        yuvConverter = new YuvConverter(getApplicationContext(), bytesList.get(0).length, bytesList.get(1).length, height, width);
                                        Log.i("flutter ", "yuv_transform init YuvConverter in " + ((new Date().getTime() - start)) + " ms");
                                    }

                                    total_calls += 1;
                                    long startTime = new Date().getTime();
                                    try {
                                        /*
                                         * hardcoded assuptions:
                                         *   stride[0] (yLine) >= width
                                         *   stride[1] (yPixel) == 1
                                         *   stride[2] (uLine) >= width
                                         *   stride[3] (uPixel) == 2
                                         *   stride[4] (vLine) == uLine
                                         *   stride[5] (vPixel) == uPixel
                                         */
                                        Bitmap bitmapRaw = yuvConverter.YUV420toRGB(bytesList.get(0), bytesList.get(1), bytesList.get(2), strides[0], strides[2], height, width);

                                        long conversion = new Date().getTime() - startTime;
                                        total_conversion += conversion;
                                        Log.i("flutter ", "yuv_transform bitmap " + width + "x" + height + " in " + (new Date().getTime() - startTime) + " ms, average "  + total_conversion/total_calls);

                                        total_rotation += new Date().getTime() - startTime;
                                        Log.i("flutter ", "yuv_transform rotated bitmap " + height + "x" + width + " in " + (new Date().getTime() - startTime - conversion) + " ms, average "  + (total_rotation-total_conversion)/total_calls);

                                        long ts = new Date().getTime();
                                        ByteArrayOutputStream outputStreamCompressed = new ByteArrayOutputStream();
                                        bitmapRaw.compress(Bitmap.CompressFormat.JPEG, 60, outputStreamCompressed);

                                        total_jpeg += new Date().getTime() - startTime;
                                        Log.i("flutter ", "yuv_transform jpeg compression " + (new Date().getTime()-ts) + " average " + (total_jpeg-total_rotation)/total_calls + " ms");

                                        if (total_calls == -20) {
                                            FileOutputStream jpg = new FileOutputStream(new File(getCacheDir(), "rotated.jpg"));
                                            jpg.write(outputStreamCompressed.toByteArray());
                                            jpg.close();
                                            Log.i("flutter ", "yuv_transform rotated Jpeg saved to " + new File(getCacheDir(), "rotated.jpg"));
                                        }

                                        result.success(outputStreamCompressed.toByteArray());
                                        outputStreamCompressed.close();
                                    } catch (IOException e) {
                                        e.printStackTrace();
                                    }
                                    break;
                                }
                            }
                        }
                );

    }

}
