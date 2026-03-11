package com.rnspmdynamicpoc

import com.facebook.react.bridge.ReactApplicationContext

class RnSpmDynamicPocModule(reactContext: ReactApplicationContext) :
  NativeRnSpmDynamicPocSpec(reactContext) {

  override fun multiply(a: Double, b: Double): Double {
    return a * b
  }

  companion object {
    const val NAME = NativeRnSpmDynamicPocSpec.NAME
  }
}
