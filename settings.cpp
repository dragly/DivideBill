#include "settings.h"

Settings::Settings(QObject *parent) :
    QSettings("dragly", "SplitBill", parent)
{
}

void Settings::setValue(QString key, QVariant value)
{
    QSettings::setValue(key, value);
}

QVariant Settings::value(QString key, QVariant defaultValue)
{
    return QSettings::value(key, defaultValue);
}
