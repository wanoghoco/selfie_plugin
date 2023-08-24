package com.example.bvn_selfie;

public interface BVNCallbacks {
    void onTextTureCreated(String val,long textureId);
    void gestureCallBack(String methodName,int id);
    void actionCallBack(int action);
    void onProgressChanged(int count);
    void onImageCapture(String imagePath);
    void onError(String error);
}
