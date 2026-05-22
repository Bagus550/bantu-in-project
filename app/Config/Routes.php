<?php

use CodeIgniter\Router\RouteCollection;

/**
 * @var RouteCollection $routes
 */
$routes->get('/', 'Home::index');

$routes->post('api/tasks/create', 'TaskController::createTask');

$routes->get('api/tasks/feed', 'TaskController::feed');

$routes->group('api', function ($routes) {
    $routes->get('tasks/feed', 'TaskController::feed');
});
