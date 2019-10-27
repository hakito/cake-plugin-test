#!/bin/ash
echo "$@"
if [ ! -f /plugin_name ]; then
    PLUGIN_NAME=$(grep installer-name /plugin/composer.json | cut -d ':' -f 2)
    PLUGIN_NAME=${PLUGIN_NAME//'"'}
    PLUGIN_NAME=${PLUGIN_NAME//' '}

    echo $PLUGIN_NAME > /plugin_name


    cd /cakephp/app/Plugin

    ln -s /plugin $PLUGIN_NAME

    cd ..
    echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
    <phpunit bootstrap=\"Vendor/autoload.php\">
    <filter>
        <whitelist>
            <directory suffix=\".php\">Plugin/$PLUGIN_NAME</directory>
            <exclude>
                <directory suffix=\".php\">Plugin/$PLUGIN_NAME/Test</directory>
            </exclude>
        </whitelist>
    </filter>
    </phpunit>" > phpunit.xml    
fi

PLUGIN_NAME=$(cat /plugin_name)
cd /cakephp/app
php Console/cake.php test $PLUGIN_NAME "$@"
