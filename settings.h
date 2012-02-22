#ifndef SETTINGS_H
#define SETTINGS_H

#include <QSettings>

class Settings : public QSettings
{
    Q_OBJECT
public:
    explicit Settings(QObject *parent = 0);

    Q_INVOKABLE void setValue(QString key, QVariant value);
    Q_INVOKABLE QVariant value(QString key, QVariant defaultValue = QVariant());

signals:

public slots:

};

#endif // SETTINGS_H
