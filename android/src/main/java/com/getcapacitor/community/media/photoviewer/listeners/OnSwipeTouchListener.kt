package com.getcapacitor.community.media.photoviewer.listeners

import android.content.Context
import android.view.GestureDetector
import android.view.MotionEvent
import android.view.View

internal open class OnSwipeTouchListener (c: Context?) :
  View.OnTouchListener {
  private val gestureDetector: GestureDetector

  override fun onTouch(view: View, motionEvent: MotionEvent): Boolean {
    return gestureDetector.onTouchEvent(motionEvent)
  }
  private inner class GestureListener: GestureDetector.SimpleOnGestureListener() {
    private val SWIPE_THRESHOLD: Int = 100
    private val SWIPE_VELOCITY_THRESHOLD: Int = 200
    override fun onFling(
      downEvent: MotionEvent?,
      moveEvent: MotionEvent,
      velocityX: Float,
      velocityY: Float
    ): Boolean {
      var diffX = moveEvent.x.minus(downEvent!!.x)
      var diffY = moveEvent.y.minus(downEvent.y)

      return if(Math.abs(diffX) > Math.abs(diffY)) {
        // this is a left or right swipe
        if(Math.abs(diffX) > SWIPE_THRESHOLD && Math.abs(velocityX) > SWIPE_VELOCITY_THRESHOLD) {
          if(diffX > 0) {
            onSwipeRight()
          } else {
            onSwipeLeft()
          }
          true
        } else {
          super.onFling(downEvent, moveEvent, velocityX, velocityY)
       }
      } else {
        // this is a up or down swipe
        if(Math.abs(diffY) > SWIPE_THRESHOLD && Math.abs(velocityY) > SWIPE_VELOCITY_THRESHOLD) {
          if(diffY > 0) {
            onSwipeDown()
          } else {
            onSwipeUp()
          }
          true
        } else {
          super.onFling(downEvent, moveEvent, velocityX, velocityY)
        }
}
}
}
open fun onSwipeRight() {}
open fun onSwipeLeft() {}
open fun onSwipeUp() {}
open fun onSwipeDown() {}
init {
gestureDetector = GestureDetector(c, GestureListener())
}

}
