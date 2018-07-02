#include "Abstraction.h"
#include "AbstractionImp.h"

#include <iostream>
using namespace std;

Abstraction::Abstraction()
{
}


Abstraction::~Abstraction()
{
}

void Abstraction::Operation()
{

}

RefinedAbstraction::RefinedAbstraction(AbstractionImp * imp)
{
	_imp = imp;
}

RefinedAbstraction::~RefinedAbstraction()
{
}

void RefinedAbstraction::Operation()
{
	_imp->Operation();
}
