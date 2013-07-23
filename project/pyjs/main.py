import pyjd # this is dummy in pyjs.

from pyjamas.ui.RootPanel import RootPanel
from pyjamas.ui.Label import Label
from pyjamas import Window


if __name__ == '__main__':
    pyjd.setup("")

    RootPanel().add(Label("Hello World"))
    Window.alert("Hello World")
