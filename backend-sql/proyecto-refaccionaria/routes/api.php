<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
 
use App\Http\Controllers\Api\ProductoController;

// Esta sola línea crea rutas para: Listar, Crear, Ver uno, Actualizar y Borrar
Route::apiResource('productos', ProductoController::class);

