#pragma once
#include "Builder.h"
class ConcreteBuilder :
	public Builder
{
public:
	ConcreteBuilder();
	~ConcreteBuilder();

	// Í¨¹ý Builder ¼Ì³Ð
	virtual void BuildPartA(const string & buildPara) override;
	virtual void BuildPartB(const string & buildPara) override;
	virtual void BuildPartC(const string & buildPara) override;
	virtual Product * GetProduct() override;
};

