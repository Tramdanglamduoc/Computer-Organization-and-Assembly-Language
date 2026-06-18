#include <iostream>
using namespace std;

extern "C" int Ones(unsigned, int);

extern int ones_c(unsigned, int);

int main()
{
	int data = -2, n = 32, result;

	// Assembly procedure ==============
	result = Ones(data, n);
	cout << "Assembly result " << result << endl;

	// C++ function ====================
	result = ones_c(data, n);
	cout << "C++ result " << result << endl;
}
