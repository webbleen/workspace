#include "Product.h"

#include <iostream>
using namespace std;

Product::Product()
{
	ProducePart();
	cout << "return a product" << endl;
}

Product::~Product()
{

}

void Product::ProducePart()
{
	cout << "build part of product.." << endl;
}
/*
ProducePart::ProducePart()
{
	cout << "build product part.." << endl;
}

ProducePart::~ProducePart()
{
}
*/
ProducePart * ProducePart::BuildPart()
{
	return new ProducePart();
}
