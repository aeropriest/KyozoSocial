package ai.axartoys.meetmaxi;

import android.content.Intent;
import android.os.Bundle;
import android.speech.RecognizerIntent;
import android.speech.SpeechRecognizer;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.ArrayList;
import java.util.Locale;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "ai.axartoys.meetmaxi/speech";
    private static final int SPEECH_REQUEST_CODE = 0;
    private Result speechResult;
    
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler(new MethodCallHandler() {
                @Override
                public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
                    if (call.method.equals("startSpeechRecognition")) {
                        speechResult = result;
                        startSpeechRecognition();
                    } else {
                        result.notImplemented();
                    }
                }
            });
    }
    
    private void startSpeechRecognition() {
        Log.d("SPEECH_TEST", "Starting Android speech recognition");
        Intent intent = new Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH);
        intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM);
        intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE, Locale.getDefault());
        intent.putExtra(RecognizerIntent.EXTRA_PROMPT, "Say something");
        
        // Add flags to handle errors more gracefully
        intent.putExtra(RecognizerIntent.EXTRA_PARTIAL_RESULTS, true);
        intent.putExtra(RecognizerIntent.EXTRA_MAX_RESULTS, 3);
        intent.putExtra(RecognizerIntent.EXTRA_SPEECH_INPUT_MINIMUM_LENGTH_MILLIS, 1000L);
        intent.putExtra(RecognizerIntent.EXTRA_SPEECH_INPUT_COMPLETE_SILENCE_LENGTH_MILLIS, 1500L);
        intent.putExtra(RecognizerIntent.EXTRA_SPEECH_INPUT_POSSIBLY_COMPLETE_SILENCE_LENGTH_MILLIS, 1000L);
        
        try {
            startActivityForResult(intent, SPEECH_REQUEST_CODE);
            Log.d("SPEECH_TEST", "Speech recognition activity started");
        } catch (Exception e) {
            Log.e("SPEECH_TEST", "Error starting speech recognition: " + e.getMessage());
            speechResult.error("SPEECH_ERROR", e.getMessage(), null);
            speechResult = null;
        }
    }
    
    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        if (requestCode == SPEECH_REQUEST_CODE && speechResult != null) {
            Log.d("SPEECH_TEST", "Speech recognition activity result received: " + resultCode);
            
            if (resultCode == RESULT_OK && data != null) {
                ArrayList<String> results = data.getStringArrayListExtra(RecognizerIntent.EXTRA_RESULTS);
                if (results != null && !results.isEmpty()) {
                    String recognizedText = results.get(0);
                    Log.d("SPEECH_TEST", "Speech recognized: " + recognizedText);
                    speechResult.success(recognizedText);
                } else {
                    Log.d("SPEECH_TEST", "No speech recognized");
                    speechResult.error("NO_SPEECH", "No speech was recognized", null);
                }
            } else if (resultCode == RESULT_CANCELED) {
                // Handle cancellation or error
                String errorMessage = "No speech was detected. Please try again.";
                
                Log.d("SPEECH_TEST", "Speech recognition cancelled or failed");
                speechResult.error("NO_SPEECH", errorMessage, null);
            } else {
                Log.d("SPEECH_TEST", "Speech recognition failed with result code: " + resultCode);
                speechResult.error("UNKNOWN_ERROR", "Speech recognition failed", null);
            }
            
            speechResult = null;
        } else {
            super.onActivityResult(requestCode, resultCode, data);
        }
    }
}
