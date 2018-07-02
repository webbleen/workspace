#include "Adapter.h"
#include <iostream>

Target::Target()
{
}

Target::~Target()
{
}

void Target::Request()
{
	std::cout << "Target::Request" << std::endl;
}

Adaptee::Adaptee()
{
}

Adaptee::~Adaptee()
{
}

void Adaptee::SpecificRequest()
{
	std::cout << "Adaptee::SpecificRequest" << std::endl;
}

Adapter::Adapter()
{
}

Adapter::~Adapter()
{
}

void Adapter::Request()
{
	this->SpecificRequest();
}

Adapter2::Adapter2(Adaptee * ade)
{
	_ade = ade;
}

Adapter2::~Adapter2()
{
}

void Adapter2::Request()
{
	_ade->SpecificRequest();
}
