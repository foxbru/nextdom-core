<?php

/* This file is part of NextDom Software.
 *
 * NextDom is free software: you can redistribute it and/or modify
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
 *
 * @Support <https://www.nextdom.org>
 * @Email   <admin@nextdom.org>
 * @Authors/Contributors: Sylvaner, Byackee, cyrilphoenix71, ColonelMoutarde, edgd1er, slobberbone, Astral0, DanoneKiD
 */

namespace NextDom\Controller;

use NextDom\Helpers\NextDomHelper;
use NextDom\Helpers\Render;
use NextDom\Managers\ConfigManager;
use NextDom\Managers\JeeObjectManager;
use NextDom\Managers\ScenarioManager;

class ScenarioController extends BaseController
{
    /**
     * Render scenario page
     *
     * @param array $pageData Page data
     *
     * @return string Content of scenario page
     *
     * @throws \Exception
     */
    public static function get(&$pageData): string
    {

        $pageData['scenarios'] = array();
        // Get all scenarios without groups
        $pageData['scenariosWithoutGroup'] = ScenarioManager::all(null);
        $pageData['scenarioListGroup'] = ScenarioManager::listGroup();
        $pageData['scenarioCount'] = count($pageData['scenariosWithoutGroup']);
        // Get all scenarios with groups
        if (is_array($pageData['scenarioListGroup'])) {
            foreach ($pageData['scenarioListGroup'] as $group) {
                $pageData['scenarios'][$group['group']] = ScenarioManager::all($group['group']);
                ++$pageData['scenarioCount'];
            }
        }
        $pageData['scenarioInactiveStyle'] = NextDomHelper::getConfiguration('eqLogic:style:noactive');
        $pageData['scenariosEnabled'] = ConfigManager::byKey('enableScenario');
        $pageData['scenarioAllObjects'] = JeeObjectManager::all();

        $pageData['JS_END_POOL'][] = '/public/js/desktop/tools/scenario.js';
        $pageData['JS_END_POOL'][] = '/public/js/adminlte/utils.js';


        return Render::getInstance()->get('/desktop/tools/scenario.html.twig', $pageData);
    }

}
