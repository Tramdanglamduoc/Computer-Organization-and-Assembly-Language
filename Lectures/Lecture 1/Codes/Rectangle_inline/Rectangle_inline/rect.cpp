#include <iostream>
using namespace std;
void main()
{ //Calculate perimeter of the rectangle

  	int w = 100, h = 20;
	int p;  
	_asm{
		mov	eax, w	
		add	eax, h		; w+h
		add	eax, eax   	;calculate perimeter as 2*(w+h)
		mov	p, eax		
	}
	cout << "Assembly result is " << p << endl;

	p = 2*(w+h);
	cout << "C++ result is " << p << endl;
}
