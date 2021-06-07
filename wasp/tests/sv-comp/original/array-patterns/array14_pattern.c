/*


   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

/* Program Description :-
 * A square 2D array is declared.
 * All elements are initialized with 0.
 * In while(1) loop,  two indices are selected non-deterministically.
 * Array[index1][index2] is initialized with num^4, if it is antidiagonal element. 
 * Sum of array should never exceed rowsize/columnsize. 
 * */

extern void abort(void);
extern void __assert_fail(const char *, const char *, unsigned int, const char *) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__noreturn__));
void reach_error() { __assert_fail("0", "array14_pattern.c", 27, "reach_error"); }
extern void abort(void);
void assume_abort_if_not(int cond) {
  if(!cond) {abort();}
}
void __VERIFIER_assert(int cond) { if(!(cond)) { ERROR: {reach_error();abort();} } }
extern int __VERIFIER_nondet_int() ;
extern short __VERIFIER_nondet_short() ;

signed long long ARR_SIZE ;

int main()
{
	ARR_SIZE = (signed long long)__VERIFIER_nondet_short() ;
	assume_abort_if_not(ARR_SIZE > 0) ;

  int **array = (int**)malloc(sizeof(int*)*ARR_SIZE);
  for (int i = 0; i < ARR_SIZE; ++i) array[i] = (int*)malloc(sizeof(int)*ARR_SIZE);
	
	int row = 0, column = 0, num = -1 ;
       	signed long long sum = 0 ;
	int temp ;
	signed long long index1,index2 ;

	for(row=0;row<ARR_SIZE;row++)
		for(column=0;column<ARR_SIZE;column++)
			array[row][column] = 0 ;

	while(1)
        {
		
		index1 = (signed long long)__VERIFIER_nondet_short() ;
		index2 = (signed long long)__VERIFIER_nondet_short() ;
		assume_abort_if_not(index1>=0 && index1 < ARR_SIZE) ;
		assume_abort_if_not(index2>=0 && index2 < ARR_SIZE) ;

		array[index1][index2] = (index1+index2 == ARR_SIZE-1) ? (num*num*num*num) : array[index1][index2] ;
		

		temp = __VERIFIER_nondet_int() ;
		if(temp == 0) break ;
	}

	for(row=0;row<ARR_SIZE;row++)
		for(column=0;column<ARR_SIZE;column++)
			sum = sum + array[row][column] ;

	__VERIFIER_assert(sum >= 0 && sum <= ARR_SIZE) ;
	return 0 ;
}

		
