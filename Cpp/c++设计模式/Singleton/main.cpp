#include "Sample.h"

int main()
{
	CSample *p = CSample::Instance();
	CSample& r = CSample::InstanceRef();
	return 0;
}