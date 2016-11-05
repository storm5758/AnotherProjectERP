<?php

/**
 * MuWebCloneEngine
 * Version: 1.6
 * User: epmak
 * 12.04.2016
 * v 0.1
 **/
namespace mwce;
/**
 * Class DicBuilder
 * @package mwce
 *
 * помогает строить/перестраивать языковые словари
 */
class DicBuilder
{
    /**
     * @var null|string
     * полный адрес до файла словаря, включая расширение(если есть)
     */
    private $location;

    /**
     * DicBuilder constructor.
     * @param string|null $location
     */
    public function __construct($location = null)
    {
        $this->location = $location;
    }

    /**
     * @param array $array
     * @param null|string $location
     */
    public function buildDic($array, $location = null)
    {
        if (!is_null($location))
            $this->location = $location;

        $content = '<?php return array(';
        $ai = new \ArrayIterator($array);

        foreach ($ai as $id => $value) {
            $content .= '"' . $id . '"=>"' . $value . '",';
        }

        $content .= ');';

        $this->writeThis($content);
    }

    /**
     * запись словаря
     * @param string $content
     */
    private function writeThis($content)
    {
        file_put_contents($this->location, $content, LOCK_EX);
    }

    /**
     * @param string $path
     * @return array|mixed
     */
    public static function getLang($path){

        if(file_exists($path))
            $l = include $path;
        else
            return array();

        if(!is_array($l))
            return array();

        return $l;
    }

    /**
     * Запись в словарь данных
     * @param string $value данные
     * @param string $preffix часть названия ключа массива
     * @return bool|string  ключ от добавленного элеента
     */
    public function add2Dic($value,$preffix='auto_lang')
    {
        if(!file_exists($this->location))
            return false;

        $container = include $this->location;
        $i=0;

        if(!empty($container))
        {
            while (isset($container[$preffix.$i]))
            {
                $i++;
            }

            $container[$preffix.$i] = $value;
            self::buildDic($container);
            return $preffix.$i;
        }
        else{
            $container[$preffix.'0'] = $value;
            self::buildDic($container);
            return $preffix.'0';
        }
    }
}