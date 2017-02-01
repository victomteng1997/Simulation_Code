function a = argument(z)
   re = real(z);
   im = imag(z);
   if im
     if re
       a = atan(im/re);
     else
       a = sign(im) * pi/2;
     end
   else
     if re < 0
       a = pi;
     else
       a = 0;
     end
   end
end