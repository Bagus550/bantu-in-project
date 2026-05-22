<?php
namespace App\Controllers;

use App\Models\TaskModel;
use CodeIgniter\RESTful\ResourceController;

class TaskController extends ResourceController
{
    public function createTask()
    {
        $idRequester = $this->request->getVar("id_requester");
        $kategori = $this->request->getVar("kategori_layanan");
        $judul = $this->request->getVar("judul_tugas");
        $deskripsi = $this->request->getVar("deskripsi");
        $lokasi = $this->request->getVar("lokasi_tugas");

        if (empty($idRequester) || empty($kategori) || empty($judul) || empty($deskripsi) || empty($lokasi)) {
            return $this->fail("Data wajin diisi", 400);
        }

        $nominalHarga = 0;
        switch ($kategori){
            case "Perbaikan":
                $nominalHarga = 50000;
                break;
            case "Pembersihan":
                $nominalHarga = 35000;
                break;
            case "Belanja":
                $nominalHarga = 25000;
                break;
            default:
                $nominalHarga = 15000;
                break;
        }

        $dataBaru = [
            'Id_requester' => $idRequester,
            'kategori_layanan' => $kategori,
            'judul_tugas' => $judul,
            'deskripsi' => $deskripsi,
            'lokasi_tugas' => $lokasi,
            'status_task' => 'mencari_helper'
        ];

        $model = new TaskModel();
        if ($model->insert($dataBaru)) {
            return $this->respondCreated([
                'status'  => true,
                'message' => 'Tugas berhasil dibuat!',
                'data'    => [
                    'tarif_terkunci' => $nominalHarga
                ]
            ]);
        } else {
            return $this->fail('Gagal tersimpan!', 500);
        }
    }

    public function feed()
    {
        $model = new TaskModel();
        
        // Mengambil tugas yang statusnya masih 'mencari_helper'
        // diurutkan dari yang paling baru dimasukkan (id DESC)
        $tasks = $model->where('status_task', 'mencari_helper')
                       ->orderBy('id', 'DESC') // Sesuaikan nama primary key jika bukan 'id'
                       ->findAll();

        if (!empty($tasks)) {
            return $this->respond([
                'status'  => true,
                'message' => 'Daftar tugas berhasil diambil.',
                'data'    => $tasks
            ], 200);
        } else {
            // Kalau di database masih kosong melompong
            return $this->respond([
                'status'  => true,
                'message' => 'Belum ada tugas tersedia saat ini.',
                'data'    => []
            ], 200);
        }
    }
}