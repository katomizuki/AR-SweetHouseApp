#include <metal_stdlib>

//[[kernel]]
//void toon(uint gid [[thread_position_in_grid]],
//            texture2d<half, access::read> inColor [[texture(0)]],
//            texture2d<half, access::write> outColor [[texture(1)]])
//{
//    half4 color = inColor = inColor.read(gid);
//    outColor.write(color, gid);
//}
