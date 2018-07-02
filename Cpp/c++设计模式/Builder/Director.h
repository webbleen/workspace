#pragma once
class Builder;

class Director
{
public:
	Director(Builder* bld);
	~Director();

	void Construct();
private:
	Builder * _bld;
};

