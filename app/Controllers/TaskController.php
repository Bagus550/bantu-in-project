<?php

namespace App\Controllers;

use App\Models\TaskModel;
use CodeIgniter\RESTful\ResourceController;

class TaskController extends ResourceController
{
    public function createTask()
    {
        $idRequester    = $this->request->getVar("id_requester");
        $kategori       = $this->request->getVar("kategori_layanan");
        $judul          = $this->request->getVar("judul_tugas");
        $deskripsi      = $this->request->getVar("deskripsi");
        $lokasi         = $this->request->getVar("lokasi_tugas");

        if (empty($idRequester) || empty($kategori) || empty($judul) || empty($deskripsi) || empty($lokasi)) {
            return $this->respond([
                'status'  => false,
                'message' => 'Data wajib diisi!'
            ], 400);
        }

        $nominalHarga = 0;
        switch ($kategori) {
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
            'id_requester'      => $idRequester,
            'kategori_layanan'  => $kategori,
            'judul_tugas'       => $judul,
            'deskripsi'         => $deskripsi,
            'lokasi_tugas'      => $lokasi,
            'nominal_pembayaran' => $nominalHarga,
            'status_task'       => 'mencari_helper'
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
            return $this->respond([
                'status'  => false,
                'message' => 'Gagal menyimpan data ke database.'
            ], 500);
        }
    }

    public function feed()
    {
        try {
            $model = new TaskModel();

            $primaryKey = $model->primaryKey;

            $tasks = $model->where('status_task', 'mencari_helper')
                ->orderBy($primaryKey, 'DESC')
                ->findAll();

            if (!empty($tasks)) {
                return $this->respond([
                    'status'  => true,
                    'message' => 'Daftar tugas berhasil diambil.',
                    'data'    => $tasks
                ], 200);
            } else {
                return $this->respond([
                    'status'  => true,
                    'message' => 'Belum ada tugas tersedia saat ini.',
                    'data'    => []
                ], 200);
            }
        } catch (\Exception $e) {
            return $this->respond([
                'status'  => false,
                'message' => 'Terjadi kesalahan pada server: ' . $e->getMessage(),
                'data'    => []
            ], 500);
        }
    }

    public function getTasksByRequester()
    {
        $idRequester = $this->request->getGet('id_requester');

        if (!$idRequester) {
            return $this->response->setJSON([
                'status'  => false,
                'message' => 'Parameter id_requester tidak ditemukan.'
            ])->setStatusCode(400);
        }
        $taskModel = new \App\Models\TaskModel();

        $data = $taskModel->select('tasks.*, helpers.nama as nama_helper')
            ->join('helpers', 'helpers.id_helper = tasks.id_helper', 'left')
            ->where('tasks.id_requester', $idRequester)
            ->findAll();

        return $this->response->setJSON([
            'status'  => true,
            'message' => 'Daftar tugas requester berhasil diambil.',
            'data'    => $data
        ])->setStatusCode(200);
    }
}
