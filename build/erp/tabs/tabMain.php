<?php

/**
 * MuWebCloneEngine
 * Created by epmak
 * 15.12.2016
 *
 **/
namespace build\erp\tabs;
use build\erp\inc\AprojectTabs;
use build\erp\inc\eController;
use build\erp\inc\Project;
use build\erp\inc\User;
use build\erp\tabs\m\mProjectPlan;
use build\erp\tabs\m\mTabMain;
use mwce\html_;
use mwce\router;
use mwce\Tools;


class tabMain extends AprojectTabs
{
    /**
     * @var mTabMain
     * переопределил под текущий контент
     */
    protected $project;

    protected $postField = array(
        'projectNane' => ['type'=>self::STR,'maxLength'=>200],
        'projectDesc' => ['type'=>self::STR],
        'curManager' => ['type'=>self::INT],
        'planState' => ['type'=>self::INT],
        'descState' => ['type'=>self::STR],
        'descStage' => ['type'=>self::STR],
    );

    protected $getField = array(
        'type' => ['type'=>self::INT],
        'desc' => ['type'=>self::STR],
    );

    /**
     * главный вид по умолчанию
     * @param null $params
     * @return void
     */
    public function In($params=null)
    {
        if(empty($this->project)){
            $this->view
                ->set(['errTitle'=>'Ошибка','msg_desc'=>'Данные по выбранному проекту не найдены!'])
                ->out('error');
        }
        else{
            $users = User::getUserList();

            if(self::WriteAccess()){
                $this->view->emptyName('customVizStyle');
            }
            else{
                $this->view->set('customVizStyle','display:none');
            }

            if($this->project['col_statusID'] == 4 && $this->project['col_respID'] == router::getCurUser()){
                $this->view->set('chooseStageStyle','');
            }
            else{
                $this->view->set('chooseStageStyle','display:none;');
            }

            $this->view
                ->add_dict($this->project)
                ->set('mngrList',html_::select($users,'curManager',$this->project['col_founderID'],'class="form-control inlineBlock"'))
                ->out('main',$this->className);
        }
    }

    public function stageAction(){
        if(!empty($_GET['type'])){
            if($this->project['col_statusID'] == 4 && $this->project['col_respID'] == router::getCurUser()){
                switch ($_GET['type']){
                    case 1:
                        $this->project->stageAgree();
                        echo json_encode(['success'=>1]);
                        break;
                    case 2:
                        if(!empty($_GET['desc'])){
                            $this->project->stageDisagree($_GET['desc']);
                            echo json_encode(['success'=>1]);
                        }
                        else{
                            echo json_encode(['error'=>'Не указана причина отказа']);
                            exit;
                        }
                        break;
                    default:
                        echo json_encode(['error'=>'Ошибка данных!']);
                        exit;
                        break;
                }
            }
            else
                echo json_encode(['error'=>'Только ответственный за стадию может принимать решение!']);
        }
    }

    public function save(){

        if(!self::WriteAccess()){
            echo json_encode(['error'=>'У Вас нет доступа для записи!']);
        }
        else{
            if(empty($_POST['curManager']))
                return;

            if(empty($this->project)){
                echo json_encode(['error'=>'Запрашиваемый проект не найден!']);
            }
            else{
                $params = array();
                $params['col_projectName'] = !empty($_POST['projectNane']) ? "'{$_POST['projectNane']}'" : 'NULL';
                $params['col_Desc'] = !empty($_POST['projectDesc']) ? "'{$_POST['projectDesc']}'" : 'NULL';
                $params['col_founderID'] = $_POST['curManager'];
                $this->project->save($params);
            }
        }
    }

    public function __construct(\mwce\content $view, $pages, $project)
    {
        eController::__construct($view, $pages);
        $this->project = mTabMain::getCurModel($project);
    }

    /**
     * Включение/отключение автоплана
     */
    public function switchPlan(){
        if(isset($_POST['planState']) && $this->project['col_ProjectPlanState'] != $_POST['planState']){
            if($this->project['col_ProjectPlanState'] == 1 && empty($_POST['descState'])){
                echo json_encode(['error'=>'Пожалуйста, укажите причину выключения авто-плана']);
            }
            else{
                $stageInfo = mProjectPlan::getCurModel($this->project['col_pstageID']);
                if(!empty($stageInfo)){
                    //просрочка по стадии, а если так, то нужно указать причину просрочки
                    if(strtotime($stageInfo['col_dateEndPlan']) < time() && empty($_POST['descStage'])){
                        echo json_encode(['stageIsLate'=>true]);
                    }
                    else{

                        if(!$this->project->switchPlanState(
                            $_POST['planState'],
                            !empty($_POST['descStage']) ? $_POST['descStage'] : 0,
                            !empty($_POST['descState']) ? $_POST['descState'] : ''
                        )){
                            echo json_encode(['error'=>'Не удалось запустить автоплан. Возможно, больше нет плановых стадий.']);
                        }
                        else
                            echo json_encode(['success'=>1]);
                    }
                }
                else{
                    echo json_encode(['error'=>'Ошибка при поиске стадии проекта, пожалуйста, оповестите администратора!']);
                }
            }
        }
    }

    /**
     * проверка на возможность изменения вкладки (из конфига)
     * @return bool
     */
    protected function WriteAccess(){

        $prop = self::getProperties();
        $role = explode(',',$prop['userAccessRW']);
        $group = explode(',',$prop['groupAccessRW']);

        if(in_array(router::getUserGroup(),$group) || in_array(3,$group)
            || in_array(router::getUserRole(),$role)){
            return true;
        }

        return false;
    }

}