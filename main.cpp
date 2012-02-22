#include <QtGui/QApplication>
#include <QtDeclarative>
#include "qmlapplicationviewer.h"

#include "settings.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    qmlRegisterType<Settings>("org.dragly", 1, 0, "Settings");

    QScopedPointer<QApplication> app(createApplication(argc, argv));

    QmlApplicationViewer viewer;
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/Bill/main.qml"));
    viewer.showExpanded();

    return app->exec();
}
