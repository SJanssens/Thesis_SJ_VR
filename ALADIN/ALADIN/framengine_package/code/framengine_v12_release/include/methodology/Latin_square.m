function [ a ] = Latin_square(n, seed )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
  rng(seed,'v5uniform');
  p=randperm(n);
  perm_check ( n, p );

  for i = 1 : n
    for k = 1 : n
      ik = i4_wrap ( i + k - 1, 1, n );
      a(i,p(ik)) = k;
    end
  end

  return
end



function perm_check ( n, p )

%*****************************************************************************80
%
%% PERM_CHECK checks that a vector represents a permutation.
%
%  Discussion:
%
%    The routine verifies that each of the integers from 1
%    to N occurs among the N entries of the permutation.
%
%  Licensing:
%
%    This code is distributed under the GNU LGPL license. 
%
%  Modified:
%
%    02 January 2004
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input, integer N, the number of entries.
%
%    Input, integer P(N), the array to check.
%
  missing = 0;

  for seek = 1 : n

    missing = seek;

    for find = 1 : n
      if ( p(find) == seek )
        missing = 0;
        break;
      end
    end

    if ( missing ~= 0 )
      fprintf ( 1, '\n' );
      fprintf ( 1, 'PERM_CHECK - Fatal error!\n' );
      fprintf ( 1, '  The input array does not represent\n' );
      fprintf ( 1, '  a proper permutation.  In particular, the\n' );
      fprintf ( 1, '  array is missing the value %d\n', missing );
      error ( 'PERM_CHECK - Fatal error!' );
    end

  end

  return
end


function value = i4_wrap ( ival, ilo, ihi )

%*****************************************************************************80
%
%% I4_WRAP forces an integer to lie between given limits by wrapping.
%
%  Example:
%
%    ILO = 4, IHI = 8
%
%    I   Value
%
%    -2     8
%    -1     4
%     0     5
%     1     6
%     2     7
%     3     8
%     4     4
%     5     5
%     6     6
%     7     7
%     8     8
%     9     4
%    10     5
%    11     6
%    12     7
%    13     8
%    14     4
%
%  Licensing:
%
%    This code is distributed under the GNU LGPL license.
%
%  Modified:
%
%    02 October 2006
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input, integer IVAL, an integer value.
%
%    Input, integer ILO, IHI, the desired bounds for the integer value.
%
%    Output, integer I4_WRAP, a "wrapped" version of IVAL.
%
  jlo = min ( ilo, ihi );
  jhi = max ( ilo, ihi );

  wide = jhi - jlo + 1;

  if ( wide == 1 )
    value = jlo;
  else
    value = jlo + i4_modp ( ival - jlo, wide );
  end

  return
end

function value = i4_modp ( i, j )

%*****************************************************************************80
%
%% I4_MODP returns the nonnegative remainder of I4 division.
%
%  Discussion:
%
%    If
%      NREM = I4_MODP ( I, J )
%      NMULT = ( I - NREM ) / J
%    then
%      I = J * NMULT + NREM
%    where NREM is always nonnegative.
%
%    The MOD function computes a result with the same sign as the
%    quantity being divided.  Thus, suppose you had an angle A,
%    and you wanted to ensure that it was between 0 and 360.
%    Then mod(A,360) would do, if A was positive, but if A
%    was negative, your result would be between -360 and 0.
%
%    On the other hand, I4_MODP(A,360) is between 0 and 360, always.
%
%  Example:
%
%        I     J     MOD  I4_MODP    Factorization
%
%      107    50       7       7    107 =  2 *  50 + 7
%      107   -50       7       7    107 = -2 * -50 + 7
%     -107    50      -7      43   -107 = -3 *  50 + 43
%     -107   -50      -7      43   -107 =  3 * -50 + 43
%
%  Licensing:
%
%    This code is distributed under the GNU LGPL license.
%
%  Modified:
%
%    02 March 1999
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input, integer I, the number to be divided.
%
%    Input, integer J, the number that divides I.
%
%    Output, integer VALUE, the nonnegative remainder when I is
%    divided by J.
%
  if ( j == 0 )
    fprintf ( 1, '\n' );
    fprintf ( 1, 'I4_MODP - Fatal error!\n' );
    fprintf ( 1, '  Illegal divisor J = %d\n', j );
    error ( 'I4_MODP - Fatal error!' );
  end

  value = mod ( i, j );

  if ( value < 0 )
    value = value + abs ( j );
  end

  return
end