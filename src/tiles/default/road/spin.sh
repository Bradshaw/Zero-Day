#!/bin/bash

rm $(ls | grep .*t.*png)
rm $(ls | grep .*l.*png)

convert img.png -crop 64x48 out.png
mv out-0.png tl.png
mv out-1.png t.png
mv out-2.png l.png
mv out-3.png ntl.png
