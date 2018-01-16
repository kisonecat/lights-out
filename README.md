# Scanning algorithms for *Lights Out*

A very long while ago I posted some solutions to Lights Out; back
then, I solved the n-by-n board by row-reducing an n^2-by-n^2 matrix.

Since then, both Boris Okun and Brent Werness pointed out to me that I
should've solved Lights Out by using a scanning algorithm: propagating
the button presses down one row at a time, and exponentiating the
propagation matrix to make sure that I don't get stuck at the last
row.

This is much faster.

I wrote some [SageMath code](scanning-algorithm.sage) for this
algorithm.

## Sample

```
sage: %attach scanning-algorithm.sage
sage: lights_out(5,5)
[1 1 0 0 0]
[1 1 0 1 1]
[0 0 1 1 1]
[0 1 1 1 0]
[0 1 1 0 1]
```
