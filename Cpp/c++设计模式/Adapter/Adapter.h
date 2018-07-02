#pragma once
class Target
{
public:
	Target();
	virtual ~Target();
	virtual void Request();
private:

};

class Adaptee
{
public:
	Adaptee();
	~Adaptee();
	void SpecificRequest();
private:

};

class Adapter : public Target, private Adaptee
{
public:
	Adapter();
	~Adapter();
	void Request();
private:

};

class Adapter2 : public Target
{
public:
	Adapter2(Adaptee* ade);
	~Adapter2();
	void Request();
private:
	Adaptee * _ade;
};