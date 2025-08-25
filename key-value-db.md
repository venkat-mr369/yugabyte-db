<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/a6dabc19-bd6c-4f47-86b3-d9f476f490fc" />


---

### 1. **Strings**

```
Key: "student:1:name"
Value: "Ravi Kumar"
```

---

### 2. **Bitmaps**

(Representing attendance: 1 = Present, 0 = Absent)

```
Key: "attendance:ravi"
Value: 1011010110
```

---

### 3. **Bitfield**

(Representing student scores in bits)

```
Key: "scores:anita"
Value: { 45 | 67 | 89 | 23 }
```

---

### 4. **Hashes**

(Like a dictionary)

```
Key: "student:rahul"
Value: { name: "Rahul Verma", age: 22, city: "Delhi" }
```

---

### 5. **Lists**

(Queue of students in admission order)

```
Key: "admission_queue"
Value: [ "Sita Sharma", "Arjun Reddy", "Lakshmi Menon", "Amit Patel" ]
```

---

### 6. **Sets**

(Unique names of students in Cricket team)

```
Key: "cricket_team"
Value: { "Virat", "Rohit", "Dhoni", "Hardik", "Jadeja" }
```

---

### 7. **Sorted Sets**

(Students with ranks)

```
Key: "exam_ranks"
Value: { "Asha": 1, "Neeraj": 2, "Pooja": 3, "Ramesh": 4 }
```

---

### 8. **Geospatial Indexes**

(Students with their home locations in India)

```
Key: "student_locations"
Value: { "Vikram": (28.6139, 77.2090),  // Delhi
         "Meena": (12.9716, 77.5946),  // Bangalore
         "Suresh": (19.0760, 72.8777)  // Mumbai
       }
```

---

### 9. **Hyperloglogs**

(Approximate unique visitors to college website)

```
Key: "website_visitors"
Value: { "Anjali", "Ravi", "Anjali", "Sunil", "Meena", "Sunil" }
≈ Count: 4 unique visitors
```

---

### 10. **Streams**

(Event log of student activities)

```
Key: "student_activities"
Value:
  id1 = 2025-08-25T10:00:00 { student: "Kiran", action: "Login" }
  id2 = 2025-08-25T10:05:00 { student: "Priya", action: "Submit Assignment" }
  id3 = 2025-08-25T10:10:00 { student: "Ravi", action: "Logout" }
```

---


Do you want me to **make a clean MS Word version** of this with a table + diagram (like the image you shared) so you can keep it for reference?
