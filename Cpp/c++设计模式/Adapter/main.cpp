#include "Adapter.h"

#include <iostream>
using namespace std;

int main()
{
	Target* adt = new Adapter();
	adt->Request();

	Adaptee* ate = new Adaptee();
	Target* adt2 = new Adapter2(ate);
	adt2->Request();

	return 0;
}