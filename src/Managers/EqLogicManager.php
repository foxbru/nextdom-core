<?php
/* This file is part of Jeedom.
 *
 * Jeedom is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Jeedom is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Jeedom. If not, see <http://www.gnu.org/licenses/>.
 */

/* This file is part of NextDom Software.
 *
 * NextDom Software is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * NextDom Software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with NextDom Software. If not, see <http://www.gnu.org/licenses/>.
 */

namespace NextDom\Managers;

use NextDom\Enums\DateFormat;
use NextDom\Exceptions\CoreException;
use NextDom\Helpers\DBHelper;
use NextDom\Helpers\Utils;
use NextDom\Managers\Parents\BaseManager;
use NextDom\Managers\Parents\CastedObjectManager;
use NextDom\Model\Entity\EqLogic;

/**
 * Class EqLogicManager
 * @package NextDom\Managers
 */
class EqLogicManager extends BaseManager
{
    use CastedObjectManager;

    const CLASS_NAME = EqLogic::class;
    const DB_CLASS_NAME = '`eqLogic`';

    /**
     * Cast a base eqLogic(s) to plugin eqLogic type
     *
     * @param EqLogic|EqLogic[] $eqLogicInput EqLogic to cast or array of EqLogics
     *
     * @return EqLogic|EqLogic[] Converted EqLogic(s)
     * @throws CoreException
     * @throws \ReflectionException
     */
    public static function cast($eqLogicInput)
    {
        try {
            // If array of EqLogics, recursive call on each objects
            if (is_array($eqLogicInput)) {
                $result = [];
                foreach ($eqLogicInput as $eqLogic) {
                    $result[] = self::cast($eqLogic);
                }
                return $result;
            }
            if (is_object($eqLogicInput)) {
                // Get class name to cast and check if class already exists
                $targetClassName = $eqLogicInput->getEqType_name();
                if (class_exists($targetClassName)) {
                    /** @var EqLogic $target */
                    $target = new $targetClassName();
                    $target->castFromEqLogic($eqLogicInput);
                    return $target;
                }
            }
        } catch (CoreException $e) {
            MessageManager::add('core', $e->getMessage());
            return null;
        }

        return $eqLogicInput;
    }

    /**
     * Get all eqLogics linked to object
     *
     * @param mixed $objectId Object id
     * @param bool $onlyEnable Filter only enabled
     * @param bool $onlyVisible Filter only visible
     * @param null $eqTypeName Filter by eqTypeName (Plugin type)
     * @param null $logicalId Filter by logical id (value defined by the plugin)
     * @param bool $orderByName ORDER BY `name`
     *
     * @return EqLogic[] All linked eqLogic
     *
     * @throws \Exception
     */
    public static function byObjectId($objectId, $onlyEnable = true, $onlyVisible = false, $eqTypeName = null, $logicalId = null, $orderByName = false)
    {
        $values = [];
        $sql = static::getBaseSQL() . ' ';
        if ($objectId === null) {
            $sql .= 'WHERE object_id IS NULL OR object_id = -1 ';
        } else {
            $values['object_id'] = $objectId;
            $sql .= 'WHERE `object_id` = :object_id ';
        }
        if ($onlyEnable) {
            $sql .= 'AND isEnable = 1 ';
        }
        if ($onlyVisible) {
            $sql .= 'AND isVisible = 1 ';
        }
        if ($eqTypeName !== null) {
            $values['eqType_name'] = $eqTypeName;
            $sql .= 'AND `eqType_name` = :eqType_name ';
        }
        if ($logicalId !== null) {
            $values['logicalId'] = $logicalId;
            $sql .= 'AND `logicalId` = :logicalId ';
        }
        if ($orderByName) {
            $sql .= 'ORDER BY `name`';
        } else {
            $sql .= 'ORDER BY `order`, category';
        }
        return self::cast(DBHelper::getAllObjects($sql, $values, self::CLASS_NAME));
    }

    /**
     * Get all eqLogics filtered by logicalId (defined by plugin
     *
     * @param int|string $logicalId Plugin logical ID
     * @param string $eqTypeName Type of the eqLogic (plugin)
     * @param bool $multiple True for multiple results
     *
     * @return EqLogic|EqLogic[] EqLogic or list of EqLogics
     *
     * @throws \Exception
     */
    public static function byLogicalId($logicalId, $eqTypeName, $multiple = false)
    {
        $clauses = [
            'logicalId' => $logicalId,
            'eqType_name' => $eqTypeName,
        ];
        if ($multiple) {
            $result = static::getMultipleByClauses($clauses);
        }
        else {
            $result = static::getOneByClauses($clauses);
        }
        return self::cast($result);
    }

    /**
     * @TODO: ???
     *
     * @param $eqTypeName
     * @param bool $onlyEnable
     * @return EqLogic[]|null
     * @throws \Exception
     */
    public static function byType($eqTypeName, $onlyEnable = false)
    {
        $values = [
            'eqType_name' => $eqTypeName,
        ];
        $sql = static::getPrefixedBaseSQL('el') . '
                LEFT JOIN object ob ON el.object_id = ob.id
                WHERE `eqType_name` = :eqType_name ';
        if ($onlyEnable) {
            $sql .= 'AND isEnable = 1 ';
        }
        $sql .= 'ORDER BY ob.name,el.name';
        return self::cast(DBHelper::getAllObjects($sql, $values, self::CLASS_NAME));
    }

    /**
     * Get eqLogics objets by category
     *
     * @param $category
     * @return array|mixed
     * @throws \Exception
     */
    public static function byCategory($category)
    {
        $values = [
            'category' => '%"' . $category . '":1%',
            'category2' => '%"' . $category . '":"1"%',
        ];

        $sql = static::getBaseSQL() . '
                WHERE `category` LIKE :category
                OR `category` LIKE :category2
                ORDER BY `name`';
        return self::cast(DBHelper::getAllObjects($sql, $values, self::CLASS_NAME));
    }

    /**
     * @TODO: ???
     *
     * @param $eqTypeName
     * @param $configuration
     * @return array|mixed
     * @throws \Exception
     */
    public static function byTypeAndSearhConfiguration($eqTypeName, $configuration)
    {
        $values = [
            'eqType_name' => $eqTypeName,
            'configuration' => '%' . $configuration . '%',
        ];
        $sql = static::getBaseSQL() . '
                WHERE `eqType_name` = :eqType_name
                AND `configuration` LIKE :configuration
                ORDER BY `name`';
        return self::cast(DBHelper::getAllObjects($sql, $values, self::CLASS_NAME));
    }

    /**
     * @TODO: ???
     *
     * @param $configuration
     * @param null $type
     * @return array|mixed
     * @throws \Exception
     */
    public static function searchConfiguration($configuration, $type = null)
    {
        $sql = static::getBaseSQL() . '
                WHERE `configuration` LIKE :configuration';
        if (!is_array($configuration)) {
            $values = [
                'configuration' => '%' . $configuration . '%',
            ];
        } else {
            $values = [
                'configuration' => '%' . $configuration[0] . '%',
            ];
            for ($i = 1; $i < count($configuration); $i++) {
                $values['configuration' . $i] = '%' . $configuration[$i] . '%';
                $sql .= ' OR `configuration` LIKE :configuration' . $i;
            }
        }
        if ($type !== null) {
            $values['eqType_name'] = $type;
            $sql .= ' AND `eqType_name` = :eqType_name ';
        }
        $sql .= ' ORDER BY `name`';
        return self::cast(DBHelper::getAllObjects($sql, $values, self::CLASS_NAME));
    }

    /**
     * @TODO: ??
     *
     * @param $eqTypeName
     * @param $typeCmd
     * @param string $subTypeCmd
     * @return array|mixed|null
     * @throws \Exception
     */
    public static function listByTypeAndCmdType($eqTypeName, $typeCmd, $subTypeCmd = '')
    {
        if ($subTypeCmd == '') {
            $values = [
                'eqType_name' => $eqTypeName,
                'typeCmd' => $typeCmd,
            ];
            $sql = 'SELECT DISTINCT(el.id),el.name
                    FROM ' . self::DB_CLASS_NAME . '  el
                    INNER JOIN `cmd` c ON c.eqLogic_id = el.id
                    WHERE `eqType_name` = :eqType_name
                    AND c.type = :typeCmd
                    ORDER BY `name`';
            return DBHelper::getAll($sql, $values);
        } else {
            $values = [
                'eqType_name' => $eqTypeName,
                'typeCmd' => $typeCmd,
                'subTypeCmd' => $subTypeCmd,
            ];
            $sql = 'SELECT DISTINCT(el.id),el.name
                    FROM ' . self::DB_CLASS_NAME . '  el
                    INNER JOIN `cmd` c ON c.eqLogic_id = el.id
                    WHERE `eqType_name` = :eqType_name
                    AND c.type = :typeCmd
                    AND c.subType = :subTypeCmd
                    ORDER BY `name`';
            return DBHelper::getAll($sql, $values);
        }
    }

    /**
     * @TODO: ???
     *
     * @param $objectId
     * @param $typeCmd
     * @param string $subTypeCmd
     * @return array|mixed|null
     * @throws \Exception
     */
    public static function listByObjectAndCmdType($objectId, $typeCmd, $subTypeCmd = '')
    {
        $values = [];
        $sql = 'SELECT DISTINCT(el.id), el.name
                FROM ' . self::DB_CLASS_NAME . '  el
                INNER JOIN `cmd` c ON c.eqLogic_id=el.id
                WHERE ';
        if ($objectId === null) {
            $sql .= 'object_id IS NULL ';
        } elseif ($objectId != '') {
            $values['object_id'] = $objectId;
            $sql .= '`object_id` = :object_id ';
        } else {
            return null;
        }
        if ($subTypeCmd != '') {
            $values['subTypeCmd'] = $subTypeCmd;
            $sql .= 'AND c.subType = :subTypeCmd ';
        }
        if ($typeCmd != '' && $typeCmd != 'all') {
            $values['type'] = $typeCmd;
            $sql .= 'AND c.type = :type ';
        }
        $sql .= 'ORDER BY `name`';
        return DBHelper::getAll($sql, $values);
    }

    /**
     * @TODO: ???
     *
     * @return array|mixed|null
     * @throws \Exception
     */
    public static function allType()
    {
        $sql = 'SELECT distinct(eqType_name) as type
                FROM ' . self::DB_CLASS_NAME . ' ';
        return DBHelper::getAll($sql);
    }

    /**
     * Vérifier si un objet est actif
     * @throws \Exception
     */
    public static function checkAlive()
    {
        $selfByTimeout = self::byTimeout(1, true);
        foreach ($selfByTimeout as $eqLogic) {
            $sendReport = false;
            if (count($eqLogic->getCmd()) > 0) {
                $sendReport = true;
            }
            $logicalId = 'noMessage' . $eqLogic->getId();
            if ($sendReport) {
                $noReponseTimeLimit = $eqLogic->getTimeout();
                if (count(MessageManager::byPluginLogicalId('core', $logicalId)) == 0) {
                    if ($eqLogic->getStatus('lastCommunication', date(DateFormat::FULL)) < date(DateFormat::FULL, strtotime('-' . $noReponseTimeLimit . ' minutes' . date(DateFormat::FULL)))) {
                        $message = __('Attention') . ' ' . $eqLogic->getHumanName();
                        $message .= __(' n\'a pas envoyé de message depuis plus de ') . $noReponseTimeLimit . __(' min (vérifiez les piles)');
                        $eqLogic->setStatus('timeout', 1);

                        CmdManager::checkAlertCmds('alert::addMessageOnTimeout', 'alert::timeoutCmd', $message, $logicalId);
                    }
                } else {
                    if ($eqLogic->getStatus('lastCommunication', date(DateFormat::FULL)) > date(DateFormat::FULL, strtotime('-' . $noReponseTimeLimit . ' minutes' . date(DateFormat::FULL)))) {
                        foreach (MessageManager::byPluginLogicalId('core', $logicalId) as $message) {
                            $message->remove();
                        }
                        $eqLogic->setStatus('timeout', 0);
                    }
                }
            }
        }
    }

    /**
     * @TODO: ???
     *
     * @param int $timeout
     * @param bool $onlyEnable
     * @return array|mixed
     * @throws \Exception
     */
    public static function byTimeout($timeout = 0, $onlyEnable = false)
    {
        $values = [
            'timeout' => $timeout,
        ];
        $sql = static::getBaseSQL() . '
                WHERE `timeout` >= :timeout';
        if ($onlyEnable) {
            $sql .= ' AND `isEnable` = 1';
        }
        return self::cast(DBHelper::getAllObjects($sql, $values, self::CLASS_NAME));
    }

    /**
     * @TODO: ???
     *
     * @param $input
     * @return array|mixed
     * @throws \ReflectionException
     * @throws CoreException
     */
    public static function toHumanReadable($input)
    {
        if (is_object($input)) {
            $reflections = [];
            $uuid = spl_object_hash($input);
            if (!isset($reflections[$uuid])) {
                $reflections[$uuid] = new \ReflectionClass($input);
            }
            $reflection = $reflections[$uuid];
            $properties = $reflection->getProperties();
            /** @var @var \ReflectionProperty $property */
            foreach ($properties as $property) {
                $property->setAccessible(true);
                $value = $property->getValue($input);
                $property->setValue($input, self::toHumanReadable($value));
                $property->setAccessible(false);
            }
            return $input;
        }
        if (is_array($input)) {
            foreach ($input as $key => $value) {
                $input[$key] = self::toHumanReadable($value);
            }
            return $input;
        }
        $text = $input;
        preg_match_all("/#eqLogic([0-9]*)#/", $text, $matches);
        foreach ($matches[1] as $eqLogic_id) {
            if (is_numeric($eqLogic_id)) {
                $eqLogic = self::byId($eqLogic_id);
                if (is_object($eqLogic)) {
                    $text = str_replace('#eqLogic' . $eqLogic_id . '#', '#' . $eqLogic->getHumanName() . '#', $text);
                }
            }
        }
        return $text;
    }

    /**
     * @TODO: ???
     * @throws \Exception
     */
    public static function clearCacheWidget()
    {
        foreach (static::all() as $eqLogic) {
            $eqLogic->emptyCacheWidget();
        }
    }

    /**
     * Get all eqLogics
     *
     * @param bool $onlyEnable Filter only enabled eqLogics
     *
     * @return EqLogic[]|mixed
     * @throws \Exception
     */
    public static function all($onlyEnable = false)
    {
        $sql = static::getPrefixedBaseSQL('el') . '
                LEFT JOIN object ob ON el.object_id = ob.id ';
        if ($onlyEnable) {
            $sql .= 'WHERE `isEnable` = 1 ';
        }
        $sql .= 'ORDER BY ob.name, el.name';
        return self::cast(DBHelper::getAllObjects($sql, [], self::CLASS_NAME));
    }

    /**
     * @TODO: ???
     *
     * @param $nbLine
     * @param $nbColumn
     * @param array $options
     * @return array
     */
    public static function generateHtmlTable($nbLine, $nbColumn, $options = [])
    {
        $return = ['html' => '', 'replace' => []];
        if (!isset($options['styletd'])) {
            $options['styletd'] = '';
        }
        if (!isset($options['center'])) {
            $options['center'] = 0;
        }
        if (!isset($options['styletable'])) {
            $options['styletable'] = '';
        }
        $return['html'] .= '<table style="' . $options['styletable'] . '" class="tableCmd" data-line="' . $nbLine . '" data-column="' . $nbColumn . '">';
        $return['html'] .= '<tbody>';
        for ($i = 1; $i <= $nbLine; $i++) {
            $return['html'] .= '<tr>';
            for ($j = 1; $j <= $nbColumn; $j++) {
                $styletd = (isset($options['style::td::' . $i . '::' . $j]) && $options['style::td::' . $i . '::' . $j] != '') ? $options['style::td::' . $i . '::' . $j] : $options['styletd'];
                $return['html'] .= '<td style="min-width:30px;height:30px;' . $styletd . '" data-line="' . $i . '" data-column="' . $j . '">';
                if ($options['center'] == 1) {
                    $return['html'] .= '<center>';
                }
                if (isset($options['text::td::' . $i . '::' . $j])) {
                    $return['html'] .= $options['text::td::' . $i . '::' . $j];
                }
                $return['html'] .= '#cmd::' . $i . '::' . $j . '#';
                if ($options['center'] == 1) {
                    $return['html'] .= '</center>';
                }
                $return['html'] .= '</td>';
                $return['tag']['#cmd::' . $i . '::' . $j . '#'] = '';
            }
            $return['html'] .= '</tr>';
        }
        $return['html'] .= '</tbody>';
        $return['html'] .= '</table>';

        return $return;
    }

    /**
     * Obtenir l'ensemble des tags liés aux objets
     *
     * @return array
     * @throws \Exception
     */
    public static function getAllTags()
    {
        $values = [];
        $sql = 'SELECT tags
                FROM ' . self::DB_CLASS_NAME . '
                WHERE tags IS NOT NULL
        	    AND tags!=""';
        $results = DBHelper::getAll($sql, $values);
        $return = [];
        foreach ($results as $result) {
            $tags = explode(',', $result['tags']);
            foreach ($tags as $tag) {
                $return[$tag] = $tag;
            }
        }
        return $return;
    }

    /**
     * @param $_string
     * @return EqLogic|null
     * @throws \Exception
     */
    public static function byString($_string)
    {
        $eqLogic = self::byId(str_replace(['#', 'eqLogic'], '', self::fromHumanReadable($_string)));
        if (!is_object($eqLogic)) {
            throw new CoreException(__('L\'équipement n\'a pas pu être trouvé : ') . $_string . __(' => ') . self::fromHumanReadable($_string));
        }
        return $eqLogic;
    }

    /**
     * @TODO: ???
     *
     * @param $input
     * @return array|mixed
     * @throws \Exception
     */
    public static function fromHumanReadable($input)
    {
        $isJson = false;
        if (Utils::isJson($input)) {
            $isJson = true;
            $input = json_decode($input, true);
        }
        if (is_object($input)) {
            $reflections = [];
            $uuid = spl_object_hash($input);
            if (!isset($reflections[$uuid])) {
                $reflections[$uuid] = new \ReflectionClass($input);
            }
            $reflection = $reflections[$uuid];
            $properties = $reflection->getProperties();
            /** @var \ReflectionProperty $property */
            foreach ($properties as $property) {
                $property->setAccessible(true);
                $value = $property->getValue($input);
                $property->setValue($input, self::fromHumanReadable($value));
                $property->setAccessible(false);
            }
            return $input;
        }
        if (is_array($input)) {
            foreach ($input as $key => $value) {
                $input[$key] = self::fromHumanReadable($value);
            }
            if ($isJson) {
                return json_encode($input, JSON_UNESCAPED_UNICODE);
            }
            return $input;
        }
        $text = $input;
        preg_match_all("/#\[(.*?)\]\[(.*?)\]#/", $text, $matches);
        if (count($matches) == 3) {
            $countMatches = count($matches[0]);
            for ($i = 0; $i < $countMatches; $i++) {
                if (isset($matches[1][$i]) && isset($matches[2][$i])) {
                    $eqLogic = self::byObjectNameEqLogicName($matches[1][$i], $matches[2][$i]);
                    if (isset($eqLogic[0]) && is_object($eqLogic[0])) {
                        $text = str_replace($matches[0][$i], '#eqLogic' . $eqLogic[0]->getId() . '#', $text);
                    }
                }
            }
        }
        return $text;
    }

    /**
     * @TODO: ???
     *
     * @param $objectName
     * @param $eqLogicName
     * @return array|mixed
     * @throws \Exception
     */
    public static function byObjectNameEqLogicName($objectName, $eqLogicName)
    {
        $values = [
            'eqLogic_name' => $eqLogicName,
        ];
        if ($objectName == __('Aucun')) {
            $sql = static::getBaseSQL() . '
                    WHERE `name` = :eqLogic_name
                    AND object_id IS NULL';
        } else {
            $values['object_name'] = $objectName;
            $sql = static::getPrefixedBaseSQL('el') . '
                    INNER JOIN object ob ON el.object_id=ob.id
                    WHERE el.name = :eqLogic_name
                    AND ob.name = :object_name';
        }
        return self::cast(DBHelper::getAllObjects($sql, $values, self::CLASS_NAME));
    }

    public static function deadCmdGeneric($_plugin_id) {
        $result = [];
        foreach (self::byType($_plugin_id) as $eqLogic) {
            $eqLogic_json = json_encode(utils::o2a($eqLogic));
            preg_match_all("/#([0-9]*)#/", $eqLogic_json, $matches);
            foreach ($matches[1] as $cmdId) {
                if (is_numeric($cmdId) && !CmdManager::byId(str_replace('#', '', $cmdId))) {
                    $result[] = array('detail' => ucfirst($_plugin_id).' ' . $eqLogic->getHumanName(), 'help' => 'Action', 'who' => '#' . $cmdId . '#');
                }
            }
        }
        return $result;
    }
}
