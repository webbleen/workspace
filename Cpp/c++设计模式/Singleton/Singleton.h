#pragma once
#include <iostream>
using namespace std;

template <class T>
class Singleton
{
protected:
	Singleton()
	{
		cout << "Singleton...." << endl;
		m_pInstance = static_cast< T* >(this);
	}
	~Singleton()
	{
		m_pInstance = NULL;
	}

public:
	static T* GetInstancePtr()
	{
		if (NULL == m_pInstance)
		{
			m_pInstance = new T;
		}

		return m_pInstance;
	}
	static T& GetInstanceRef()
	{
		return *GetInstancePtr();
	}

	static T* Instance()
	{
		return GetInstancePtr();
	}
	static T& InstanceRef()
	{
		return GetInstanceRef();
	}

	static void ReleaseInstance()
	{
		if (NULL != m_pInstance)
		{
			delete m_pInstance;
			m_pInstance = NULL;
		}
	}

private:
	static T* m_pInstance;
};

template<class T>
T* Singleton<T>::m_pInstance = NULL;
