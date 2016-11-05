<?php

namespace mwce;

class Logs
{
    /**
     * @param \Exception | int $errNum
     * @param string $text
     */
    public static function log($errNum, $text = '')
    {
        $dbh = Connect::start();

        if ($errNum instanceof \Exception) {
            $ec = $errNum->getCode() == 0 ? 3 : $errNum->getCode();
            $errf = substr($errNum->getFile(), 0, 254);
            $text = $errNum->getMessage(). ' Line: '.$errNum->getLine();
        }
        else
        {
            $ec = $errNum;
            $errf ='router';
        }

        $dbh->SQLog($text.'<br> Uri:'.htmlspecialchars($_SERVER['REQUEST_URI'],ENT_QUOTES), $errf, $ec);
    }

    /**
     * @param $errNum
     * @param string $text
     */
    public static function textLog($errNum, $text = '')
    {
        if (!defined('tbuild')) {
            $build = 'global';
        }
        else {
            $build = tbuild;
        }
        
        file_put_contents(baseDir . DIRECTORY_SEPARATOR . 'log' . DIRECTORY_SEPARATOR . '[' . @date("d_m_Y", time()) . ']' . $build . '_error_' . $errNum . '.txt', $text . PHP_EOL, FILE_APPEND);
    }

}