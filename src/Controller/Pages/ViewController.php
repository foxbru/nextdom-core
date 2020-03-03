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

namespace NextDom\Controller\Pages;

use NextDom\Controller\BaseController;
use NextDom\Enums\AjaxParams;
use NextDom\Enums\ControllerData;
use NextDom\Exceptions\CoreException;
use NextDom\Helpers\AuthentificationHelper;
use NextDom\Helpers\Render;
use NextDom\Helpers\Utils;
use NextDom\Managers\UserManager;
use NextDom\Managers\ViewManager;

/**
 * Class ViewController
 * @package NextDom\Controller\Pages
 */
class ViewController extends BaseController
{
    /**
     * Render view page
     *
     * @param array $pageData Page data
     *
     * @return string Content of view page
     *
     * @throws CoreException
     * @throws \ReflectionException
     */
    public static function get(&$pageData): string
    {
        $allViews = ViewManager::all();
        $viewId = Utils::init(AjaxParams::VIEW_ID);
        $pageData['viewHideList'] = true;
        $pageData['viewIsAdmin'] = AuthentificationHelper::isConnectedAsAdmin();
        $pageData['viewDefault'] = UserManager::getStoredUser()->getOptions('displayViewByDefault');
        $pageData['viewNoControl'] = Utils::init('noControl');
        $pageData['viewsList'] = $allViews;

        $currentView = null;
        if (empty($viewId)) {
            $defaultDesktopView = UserManager::getStoredUser()->getOptions('defaultDesktopView');
            if (!empty($defaultDesktopView)) {
                $currentView = ViewManager::byId($defaultDesktopView);
            }
            if (!is_object($currentView) && is_array($allViews) && count($allViews) > 0) {
                $currentView = $allViews[0];
            }
        } else {
            $currentView = ViewManager::byId($viewId);
            if (!is_object($currentView)) {
                throw new CoreException(__('Vue inconnue. Vérifier l\'ID.'));
            }
        }
        if (!is_object($currentView)) {
            throw new CoreException(__('Aucune vue n\'existe, cliquez <a href="index.php?v=d&p=view_edit">ici</a> pour en créer une.'));
        }
        $pageData['viewCurrent'] = $currentView;
        if ($pageData['viewDefault'] == 1 && Utils::init('report') != 1) {
            $pageData['viewHideList'] = false;
        }
        $pageData[ControllerData::JS_VARS][AjaxParams::VIEW_ID] = $currentView->getId();
        $pageData[ControllerData::CSS_POOL][] = '/public/css/pages/view.css';
        $pageData[ControllerData::JS_END_POOL][] = '/public/js/desktop/pages/view.js';

        return Render::getInstance()->get('/desktop/pages/view.html.twig', $pageData);
    }
}
