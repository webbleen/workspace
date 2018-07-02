// main.cpp: 定义控制台应用程序的入口点。
//


#include "Factory.h"
#include "Product.h"

#include <iostream>   
using namespace std;

int main(int argc, char const *argv[])
{
	Factory *fac = new ConcreteFactory();
	Product *p = fac->CreateProduct();

	return 0;
}