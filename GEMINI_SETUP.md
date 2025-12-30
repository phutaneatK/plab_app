# Gemini AI Chat Setup

## ขั้นตอนการตั้งค่า Gemini API Key

### 1. สร้าง API Key
ไปที่ [Google AI Studio](https://aistudio.google.com/app/apikey) เพื่อสร้าง API Key ฟรี

### 2. เพิ่ม API Key ลงในไฟล์ .env
```bash
# สำเนาไฟล์ .env.example
cp .env.example .env

# แก้ไขไฟล์ .env และใส่ API Key ของคุณ
GEMINI_API_KEY=your_actual_api_key_here
```

### 3. รันแอป
```bash
flutter pub get
flutter run
```

## หมายเหตุ
- API Key จะไม่ถูก commit ลง Git (อยู่ใน .gitignore แล้ว)
- ใช้งานฟรีได้ภายใน rate limit ของ Gemini
- หากไม่ใส่ API Key แอปจะแสดง error เมื่อส่งข้อความ

## ฟีเจอร์
- ✅ แชทกับ Gemini AI แบบ real-time
- ✅ ใช้ StreamBuilder แสดงข้อความ
- ✅ ประวัติการสนทนา
- ✅ Clean Architecture pattern
