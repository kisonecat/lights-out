#!/usr/bin/env sage
#
# scanning-algorithm is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# scanning-algorithm is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty
# of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with scanning-algorithm.  If not, see
# <http://www.gnu.org/licenses/>.

# Find a solution to the cx-by-cy "Lights Out" problem and return a
# solution as a matrix
def lights_out( cx, cy ):
    # Work over the finite field with two elements
    K = FiniteField(2)

    # This AFFINE transformation transforms (buttons pressed on the
    # first row, buttons pressed on the prevous "0th" row) into
    # (button presses NEEDED for the second row to make the first row
    # dark, buttons pressed on the first row)
    A = MatrixSpace(K,2*cx+1,2*cx+1).matrix()
    
    # We encode an affine transformation as a linear transformation on
    # a higher-dimensional vector space
    A[2*cx,2*cx] = 1

    # The lights begin all on
    for i in range(cx):
        A[ i, 2*cx ] = 1    
    
    # Each button press in the first row toggles itself and its two
    # horizontal neighbors
    for i in range(cx):
        for j in range(max(i-1,0),min(i+2,cx)):
            A[ i, j ] = 1

    # Lights previously toggled (i.e., by being below a button that
    # was pressed in the "0th" row) affect what must be pushed in this
    # row
    for i in range(cx):
        A[ i, i + cx ] = 1

    # The affine transformation simply copies the first row of button
    # pushes from the input to the output
    for i in range(cx):
        A[ i + cx, i ] = 1

    # Determine the effect the first row would have on the row past
    # the bottom edge of the board
    B = (A)^(cy)

    # Build an affine projection from the first two rows to the first
    # row by itself
    projection = MatrixSpace(K,cx+1,2*cx+1).matrix()
    for i in range(cx):
        projection[i,i] = 1
    projection[cx,2*cx] = 1

    # The transpose of the projection is an affine inclusion which
    # maps the first row into the first two rows.
    inclusion = projection.transpose()

    # find a choice of first row button pushes which, after iterating
    # the button pushes all the way down the board, doesn't require
    # any button pushes on the row past the last row
    V = VectorSpace(K,cx+1)
    top_row = (projection * B * inclusion).solve_right( V.linear_combination_of_basis( [0]*cx + [1] ) )
    top_row = inclusion * top_row

    # Proceed to walk down the board...
    row = top_row
    result = []
    for j in range(cy):
        # Use the transformation A to determine the NEXT row of button
        # pushes
        result = result + row.list()[0:cx]
        row = A * row

    # Package the result as a matrix with cx columns and cy rows
    return MatrixSpace(K,cy,cx).matrix(result)
