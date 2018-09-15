#include <iostream>
#include "WebUrl.h"

using namespace std;
using namespace crystal;

int main()
{
    try
    {
        WebUrl web("www.123.com/index.aspx?catalog=sport&id=10&rank=20&hello=hello");
        cout << web.Request("catalog") << endl;
        cout << web.Request("id") << endl;
        cout << web.Request("rank") << endl;
        cout << web.Request("hello") << endl;
        cout << web.Request("world") << endl;

        WebUrl web2("name=liwenbin&say=hello");
        cout << web2.Request("name") << endl;
        cout << web2.Request("say") << endl;

    } catch (const regex_error &e)
    {
        cout << e.code() << endl;
        cout << e.what() << endl;
    }

    return 0;
}