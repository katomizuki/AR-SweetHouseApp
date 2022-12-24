#include <metal_stdlib>
//
//using namespace metal
//[[kernel]]
//void suisai(uint gid [[thread_position_in_grid]],
//            metal::texture2d<half, metal::access::read> inColor [[texture(0)]],
//            texture2d<half, access::write> outColor [[texture(1)]])
//{
//    half4 color = inColor = inColor.read(gid);
//    outColor.write(color, gid);
//}
