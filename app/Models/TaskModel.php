<?php
namespace App\Models;

use CodeIgniter\Model;

Class TaskModel extends Model
{
    protected $table = "tasks";
    protected $primaryKey = "id_task";
    protected $useAutoIncrement = true;
    protected $returnType = 'array';
    protected $allowedFields = [
        "id_requester",
        "id_helper",
        "judul_tugas",
        "deskripsi",
        "lokasi_tugas",
        "nominal_pembayaran",
        "status_task",
        "kategori_layanan",
    ];
    protected $useTimestamps = false;
}