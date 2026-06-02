// Data Dummy untuk "Dashboard Admin" (Helper Database)
List<Map<String, dynamic>> helperDummyList = [
  {
    "id": "H001",
    "name": "Sarah Mitchell",
    "role": "Helper Bantu.In",
    "tasks": 142,
    "status": "ACTIVE",
    "avatarUrl": "https://api.dicebear.com/7.x/avataaars/svg?seed=Sarah",
  },
  {
    "id": "H002",
    "name": "Marcus Chen",
    "role": "Helper Bantu.In",
    "tasks": 89,
    "status": "SUSPENDED",
    "avatarUrl": "https://api.dicebear.com/7.x/avataaars/svg?seed=Marcus",
  },
  {
    "id": "H003",
    "name": "Elena Rodriguez",
    "role": "Helper Bantu.In",
    "tasks": 12,
    "status": "PENDING",
    "avatarUrl": "https://api.dicebear.com/7.x/avataaars/svg?seed=Elena",
  },
];

// Data Dummy untuk "Persetujuan Pembayaran" (Incoming Requests)
List<Map<String, dynamic>> paymentApprovalDummyList = [
  {
    "id": "TX-1001",
    "userName": "Aditya Pratama",
    "timeAgo": "2 mins ago",
    "amount": 450000,
    "status": "Pending Review",
    "proofImage":
        "https://images.unsplash.com/photo-1554415707-6e8cfc93fe23?q=80&w=400", // Contoh gambar struk
    "avatarUrl": "https://api.dicebear.com/7.x/avataaars/svg?seed=Aditya",
  },
  {
    "id": "TX-1002",
    "userName": "Siti Aminah",
    "timeAgo": "15 mins ago",
    "amount": 1250000,
    "status": "Pending Review",
    "proofImage":
        "https://images.unsplash.com/photo-1554415707-6e8cfc93fe23?q=80&w=400",
    "avatarUrl": "https://api.dicebear.com/7.x/avataaars/svg?seed=Siti",
  },
  {
    "id": "TX-1003",
    "userName": "Budi Santoso",
    "timeAgo": "22 mins ago",
    "amount": 850000,
    "status": "Pending Review",
    "proofImage":
        "https://images.unsplash.com/photo-1554415707-6e8cfc93fe23?q=80&w=400",
    "avatarUrl": "https://api.dicebear.com/7.x/avataaars/svg?seed=Budi",
  },
  {
    "id": "TX-1004",
    "userName": "Dewi Lestari",
    "timeAgo": "45 mins ago",
    "amount": 300000,
    "status": "Pending Review",
    "proofImage":
        "https://images.unsplash.com/photo-1554415707-6e8cfc93fe23?q=80&w=400",
    "avatarUrl": "https://api.dicebear.com/7.x/avataaars/svg?seed=Dewi",
  },
];

// Data Dummy untuk Alur "Registrasi Data Diri & Bank"
Map<String, dynamic> registrationDummyData = {
  "fullName": "Budi Santoso",
  "email": "budi.santoso@example.com",
  "password": "password123",
  "whatsAppNumber": "+628123456789",
  "bankDetails": {
    "bankName": "Bank Central Asia (BCA)",
    "accountNumber": "1234567890",
    "accountHolderName": "Budi Santoso",
  },
};
