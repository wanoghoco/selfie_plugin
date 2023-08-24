package com.example.bvn_selfie;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.graphics.PointF;
import android.graphics.Rect;
import android.graphics.SurfaceTexture;
import android.media.Image;
import android.os.Build;
import android.os.Environment;
import android.util.DisplayMetrics;
import android.util.Size;
import android.view.Surface;
import android.view.WindowManager;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.camera.core.AspectRatio;
import androidx.camera.core.Camera;
import androidx.camera.core.CameraSelector;
import androidx.camera.core.ImageAnalysis;
import androidx.camera.core.ImageCapture;
import androidx.camera.core.ImageCaptureException;
import androidx.camera.core.ImageProxy;
import androidx.camera.core.Preview;
import androidx.camera.core.SurfaceRequest;
import androidx.camera.core.impl.PreviewConfig;
import androidx.camera.lifecycle.ProcessCameraProvider;
import androidx.core.content.ContextCompat;
import androidx.core.util.Consumer;
import androidx.lifecycle.LifecycleOwner;

import static androidx.core.content.ContextCompat.checkSelfPermission;
import static androidx.core.content.ContextCompat.getMainExecutor;

import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import com.google.common.util.concurrent.ListenableFuture;
import com.google.mlkit.vision.common.InputImage;
import com.google.mlkit.vision.face.Face;
import com.google.mlkit.vision.face.FaceContour;
import com.google.mlkit.vision.face.FaceDetection;
import com.google.mlkit.vision.face.FaceDetector;
import com.google.mlkit.vision.face.FaceDetectorOptions;
import com.google.mlkit.vision.face.FaceLandmark;

import java.io.File;
import java.util.Date;
import java.util.List;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Executors;

public class VerificationService implements ImageAnalysis.Analyzer {

    private SurfaceTexture surfaceTexture;
    private Activity pluginActivity;
    private int cameraSelector= CameraSelector.LENS_FACING_FRONT;
    private ImageAnalysis imageAnalysis;
    ProcessCameraProvider processCameraProvider;
    private ListenableFuture<ProcessCameraProvider> cameraProvider;
    ImageCapture imageCapture;
    private long textureId;
    private BVNCallbacks callbacks;
    private double RATIO_4_3_VALUE = 4.0 / 3.0;
    private double RATIO_16_9_VALUE = 16.0 / 9.0;
    int counter=0;
    boolean unlocked=false;
    Thread thread ;
    private  int step=1;
    private boolean running=false;

    VerificationService(Activity activity,SurfaceTexture surfaceTexture,BVNCallbacks callbacks,long textureId){
       this.surfaceTexture=surfaceTexture;
       this.callbacks=callbacks;
       this.textureId=textureId;
       this.pluginActivity=activity;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {

            startCamera();
        }else{
           callbacks.onError("device not supported");
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    private void startCamera(){
        cameraProvider=ProcessCameraProvider.getInstance(pluginActivity.getApplicationContext());

        cameraProvider.addListener(()->{
          try{
               processCameraProvider=cameraProvider.get();
              startCamerax(processCameraProvider);
          }
          catch(ExecutionException ex){
              ex.printStackTrace();
          }
          catch (InterruptedException ex){
              ex.printStackTrace();
          }
        }, getMainExecutor(pluginActivity));
    }

    @SuppressLint({"RestrictedApi", "UnsafeOptInUsageError"})
    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    private void startCamerax(ProcessCameraProvider cameraProvider){

        int height = getDisplay().heightPixels;
        int width =  getDisplay().widthPixels;
        int screenAspectRatio = aspectRatio(width, height);

      cameraProvider.unbindAll();
      CameraSelector cameraSelector=new CameraSelector.Builder().
              requireLensFacing(CameraSelector.LENS_FACING_FRONT)
              .build();
      //preview used case
           Preview preview=new Preview.Builder()
                   .setTargetAspectRatio(screenAspectRatio)
               .build();

        preview.setSurfaceProvider(new Preview.SurfaceProvider() {
            @Override
            public void onSurfaceRequested(@NonNull SurfaceRequest request) {
                surfaceTexture.setDefaultBufferSize(width,height);
                Surface surface=new Surface(surfaceTexture);
              request.provideSurface(surface,getMainExecutor(pluginActivity), new Consumer<SurfaceRequest.Result>() {
                  @Override
                  public void accept(SurfaceRequest.Result result) {
                      // Handle the SurfaceRequest.Result if needed
                  }
              });
            }

        });

        imageAnalysis =
                new ImageAnalysis.Builder()
                        .setTargetResolution(new Size(width, height))
                        .setOutputImageFormat(ImageAnalysis.OUTPUT_IMAGE_FORMAT_YUV_420_888)
                        .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
                        .build();
        imageAnalysis.setAnalyzer(getMainExecutor(pluginActivity), this);
        //image capture used case
         imageCapture=new ImageCapture.Builder()
                 .setCaptureMode(ImageCapture.CAPTURE_MODE_ZERO_SHUTTER_LAG)
                 .setJpegQuality(50)
                 .build();
        cameraProvider.bindToLifecycle((LifecycleOwner) pluginActivity,cameraSelector,preview,imageCapture,imageAnalysis);
        callbacks.onTextTureCreated("ready",textureId);
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    @Override
    public void analyze(@NonNull ImageProxy image) {
        @SuppressLint("UnsafeOptInUsageError") Image mediaImage = image.getImage();
        if (mediaImage != null) {
            InputImage inputImage =
                    InputImage.fromMediaImage(mediaImage, image.getImageInfo().getRotationDegrees());
            FaceDetectorOptions realTimeOpts =
                    new FaceDetectorOptions.Builder()
                            .setClassificationMode(FaceDetectorOptions.CLASSIFICATION_MODE_ALL)
                            .setLandmarkMode(FaceDetectorOptions.LANDMARK_MODE_ALL)
                            .setPerformanceMode(FaceDetectorOptions.PERFORMANCE_MODE_FAST)
                            .setMinFaceSize((float)0.1)
                            .setContourMode(FaceDetectorOptions.CONTOUR_MODE_ALL)
                            .build();
            FaceDetector detector = FaceDetection.getClient(realTimeOpts);
                    detector.process(inputImage)
                            .addOnSuccessListener(
                                    new OnSuccessListener<List<Face>>() {
                                        @Override
                                        public void onSuccess(List<Face> faces) {
                                            processFacials(faces);
                                            image.close();
                                        }
                                    })
                            .addOnFailureListener(
                                    new OnFailureListener() {
                                        @Override
                                        public void onFailure(@NonNull Exception e) {
                                            System.out.println("failed");
                                            image.close();
                                        }
                                    });

        }

    }

    private DisplayMetrics getDisplay(){
        WindowManager wm = null;
        wm = (WindowManager)pluginActivity.getApplicationContext().getSystemService(pluginActivity.getApplicationContext().WINDOW_SERVICE);
        final DisplayMetrics displayMetrics = new DisplayMetrics();
        wm.getDefaultDisplay().getMetrics(displayMetrics);
        return displayMetrics;
    }

    public int aspectRatio(int width, int height) {
        double previewRatio = Double.valueOf(Math.max(width, height)) / Math.min(width, height);
        if (Math.abs(previewRatio - RATIO_4_3_VALUE) <= Math.abs(previewRatio - RATIO_16_9_VALUE)) {
            return AspectRatio.RATIO_4_3;
        }
        return AspectRatio.RATIO_16_9;
    }

    @SuppressLint("UnsafeOptInUsageError")
    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    public void processFacials(List<Face> faces){

        if(faces.size()==0){
            unlocked=true;
              if(!running&&unlocked){
                  running=true;
                  thread = new Thread(new Runnable(){
                      @Override
                      public void run() {
                          try {
                              Thread.sleep(3500);
                          } catch (InterruptedException e) {
                              e.printStackTrace();
                          }
                          if(unlocked){
                              pluginActivity.runOnUiThread(new Runnable() {
                                  @Override
                                  public void run() {
                                      callbacks.gestureCallBack(Helps.facialGesture,Helps.NO_FACE_DETECTED);
                                  }
                              });

                              running=false;
                          }
                      }
                  });
                  thread.start();
              }
            return;
        }
        unlocked=false;
        for (Face face : faces) {
            //Rect bounds = face.getBoundingBox();
//            if(bounds.width()<(getDisplay().widthPixels*0.45)){
//                callbacks.gestureCallBack(Helps.facialGesture,Helps.NO_FACE_DETECTED);
//                break;
//            }
            callbacks.gestureCallBack(Helps.facialGesture,Helps.FACE_DETECTED);

            //detection steps 1
            if(step==1){
                callbacks.actionCallBack(Helps.ROTATE_HEAD);
                if(rotateHeadX(face)&&counter==0){
                    counter+=1;
                    callbacks.onProgressChanged(counter);
                    return;
                }
                if(rotateHeadY(face)&&counter==1){
                    counter+=1;
                    callbacks.onProgressChanged(counter);
                    return;
                }
                if(rotateHeadXNEG(face)&&counter==2){
                    counter+=1;
                    callbacks.onProgressChanged(counter);
                    return;
                }
                if(rotateHeadYNEG(face)&&counter==3){
                    counter+=1;
                    step=2;
                    callbacks.onProgressChanged(counter);
                    return;
                }
               callbacks.actionCallBack(Helps.ROTATE_HEAD);
            return;
            }
            callbacks.actionCallBack(Helps.SMILE_AND_OPEN_ACTION);

            if(checkSmileAndBlick(face)){
                if(step==2){
                    step=-1;
                    takePhoto();
                }
            }


        }

    }
    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    public void takePhoto(){
        ImageCapture.OutputFileOptions outputFileOptions =
                new ImageCapture.OutputFileOptions.Builder(saveFile()).build();
        imageCapture.takePicture(outputFileOptions, Executors.newSingleThreadExecutor(),
                new ImageCapture.OnImageSavedCallback() {
                    @Override
                    public void onImageSaved(@NonNull ImageCapture.OutputFileResults outputFileResults) {
                        // Image saved successfully
                        callbacks.onImageCapture(outputFileResults.getSavedUri().getPath());
                    }

                    @Override
                    public void onError(@NonNull ImageCaptureException exception) {
                        callbacks.onError(exception.toString() );
                    }
                });
    }

    private  boolean checkSmileAndBlick(Face face){

        if (face.getSmilingProbability() != null&&face.getRightEyeOpenProbability() != null) {
            float smileProb = face.getSmilingProbability();
            float rightEyeOpenProb = face.getRightEyeOpenProbability();
            if(smileProb>0.55){
                return true;
            }
        }
        return false;
    }



    private boolean rotateHeadX(Face face){

        float degreesX =face.getHeadEulerAngleX();
        if (degreesX > 20) {

           return true;
        }
        return false;
    }
    private boolean rotateHeadY(Face face){

        float degreesY =face.getHeadEulerAngleY();
        if (degreesY > 20) {

            return true;
        }
        return false;
    }

    private boolean rotateHeadXNEG(Face face){

        float degreesX =face.getHeadEulerAngleX();
        if (degreesX < -2) {

            return true;
        }
        return false;
    }


    private boolean rotateHeadYNEG(Face face){

        float degreesY =face.getHeadEulerAngleY();
        if (degreesY < -2) {

            return true;
        }
        return false;
    }


    private File saveFile(){

        File directory = pluginActivity.getExternalFilesDir(Environment.DIRECTORY_PICTURES);
        Date date =new Date();
        String timestamp=String.valueOf(date.getTime());
       String path=directory.getAbsolutePath()+"/"+timestamp+".jpeg";
        File file = new File(path);
        return file;
    }

    @SuppressLint("RestrictedApi")
    public  void dispose(){
       if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
           processCameraProvider.unbindAll();
           processCameraProvider.shutdown();
         //  surfaceTexture.release();
         //  surfaceTexture.detachFromGLContext();
       }
   }

}
