import RnSpmDynamicPoc from './NativeRnSpmDynamicPoc';

export function multiply(a: number, b: number): number {
  return RnSpmDynamicPoc.multiply(a, b);
}

/** Calls into Alamofire – crashes at launch if AlamofireDynamic.framework isn't embedded. */
export function getVersion(): string {
  return RnSpmDynamicPoc.getVersion();
}
