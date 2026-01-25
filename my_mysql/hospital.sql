
-- 1. 科室表（Department）

CREATE TABLE department (
    dept_id VARCHAR(10) PRIMARY KEY COMMENT '科室编号',
    dept_name VARCHAR(50) NOT NULL UNIQUE COMMENT '科室名称',
    location VARCHAR(100) COMMENT '科室位置',
    phone VARCHAR(20) COMMENT '科室电话',
    description TEXT COMMENT '科室简介',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_dept_name (dept_name)
) ENGINE=InnoDB COMMENT='科室信息表';


-- 2. 医生表（Doctor）

CREATE TABLE doctor (
    doctor_id VARCHAR(20) PRIMARY KEY COMMENT '医生工号',
    doctor_name VARCHAR(50) NOT NULL COMMENT '医生姓名',
    gender ENUM('M', 'F') NOT NULL COMMENT '性别',
    birth_date DATE COMMENT '出生日期',
    phone VARCHAR(20) NOT NULL COMMENT '联系电话',
    email VARCHAR(100) COMMENT '电子邮箱',
    dept_id VARCHAR(10) NOT NULL COMMENT '所属科室',
    title ENUM('主任医师', '副主任医师', '主治医师', '住院医师') NOT NULL COMMENT '职称',
    specialty VARCHAR(200) COMMENT '专长',
    registration_fee DECIMAL(10,2) DEFAULT 0 COMMENT '挂号费',
    status ENUM('在职', '休假', '离职') DEFAULT '在职' COMMENT '状态',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (dept_id) REFERENCES department(dept_id) ON DELETE RESTRICT,
    INDEX idx_doctor_name (doctor_name),
    INDEX idx_dept_id (dept_id),
    INDEX idx_title (title)
) ENGINE=InnoDB COMMENT='医生信息表';


-- 3. 患者表（Patient）

CREATE TABLE patient (
    patient_id VARCHAR(20) PRIMARY KEY COMMENT '患者编号',
    patient_name VARCHAR(50) NOT NULL COMMENT '患者姓名',
    gender ENUM('M', 'F') NOT NULL COMMENT '性别',
    birth_date DATE NOT NULL COMMENT '出生日期',
    id_card VARCHAR(18) UNIQUE COMMENT '身份证号',
    phone VARCHAR(20) NOT NULL COMMENT '联系电话',
    address VARCHAR(200) COMMENT '家庭住址',
    emergency_contact VARCHAR(50) COMMENT '紧急联系人',
    emergency_phone VARCHAR(20) COMMENT '紧急联系电话',
    blood_type ENUM('A', 'B', 'AB', 'O', 'Unknown') DEFAULT 'Unknown' COMMENT '血型',
    allergy_history TEXT COMMENT '过敏史',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_patient_name (patient_name),
    INDEX idx_phone (phone),
    INDEX idx_id_card (id_card)
) ENGINE=InnoDB COMMENT='患者信息表';

-- 4. 医生排班表（Schedule）

CREATE TABLE doctor_schedule (
    schedule_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '排班ID',
    doctor_id VARCHAR(20) NOT NULL COMMENT '医生工号',
    work_date DATE NOT NULL COMMENT '工作日期',
    time_slot ENUM('上午', '下午', '晚上') NOT NULL COMMENT '时段',
    max_appointments INT DEFAULT 30 COMMENT '最大预约数',
    booked_count INT DEFAULT 0 COMMENT '已预约数',
    status ENUM('正常', '暂停', '取消') DEFAULT '正常' COMMENT '状态',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (doctor_id) REFERENCES doctor(doctor_id) ON DELETE CASCADE,
    UNIQUE KEY uk_schedule (doctor_id, work_date, time_slot),
    INDEX idx_work_date (work_date),
    INDEX idx_doctor_date (doctor_id, work_date)
) ENGINE=InnoDB COMMENT='医生排班表';


-- 5. 预约挂号表（Appointment）

CREATE TABLE appointment (
    appointment_id VARCHAR(30) PRIMARY KEY COMMENT '预约编号',
    patient_id VARCHAR(20) NOT NULL COMMENT '患者编号',
    doctor_id VARCHAR(20) NOT NULL COMMENT '医生工号',
    schedule_id INT NOT NULL COMMENT '排班ID',
    appointment_date DATE NOT NULL COMMENT '预约日期',
    time_slot ENUM('上午', '下午', '晚上') NOT NULL COMMENT '时段',
    queue_number INT COMMENT '排队号',
    status ENUM('已预约', '已就诊', '已取消', '爽约') DEFAULT '已预约' COMMENT '状态',
    registration_fee DECIMAL(10,2) COMMENT '挂号费',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id) ON DELETE RESTRICT,
    FOREIGN KEY (doctor_id) REFERENCES doctor(doctor_id) ON DELETE RESTRICT,
    FOREIGN KEY (schedule_id) REFERENCES doctor_schedule(schedule_id) ON DELETE RESTRICT,
    INDEX idx_patient_id (patient_id),
    INDEX idx_doctor_id (doctor_id),
    INDEX idx_appointment_date (appointment_date),
    INDEX idx_status (status)
) ENGINE=InnoDB COMMENT='预约挂号表';


-- 6. 诊断记录表（Diagnosis）

CREATE TABLE diagnosis (
    diagnosis_id VARCHAR(30) PRIMARY KEY COMMENT '诊断编号',
    appointment_id VARCHAR(30) NOT NULL COMMENT '预约编号',
    patient_id VARCHAR(20) NOT NULL COMMENT '患者编号',
    doctor_id VARCHAR(20) NOT NULL COMMENT '医生工号',
    diagnosis_date DATETIME NOT NULL COMMENT '诊断时间',
    chief_complaint TEXT COMMENT '主诉',
    present_illness TEXT COMMENT '现病史',
    physical_exam TEXT COMMENT '体格检查',
    diagnosis_result TEXT NOT NULL COMMENT '诊断结果',
    treatment_plan TEXT COMMENT '治疗方案',
    doctor_advice TEXT COMMENT '医嘱',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id) ON DELETE RESTRICT,
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id) ON DELETE RESTRICT,
    FOREIGN KEY (doctor_id) REFERENCES doctor(doctor_id) ON DELETE RESTRICT,
    INDEX idx_patient_id (patient_id),
    INDEX idx_doctor_id (doctor_id),
    INDEX idx_diagnosis_date (diagnosis_date)
) ENGINE=InnoDB COMMENT='诊断记录表';


-- 7. 药品表（Medicine）

CREATE TABLE medicine (
    medicine_id VARCHAR(20) PRIMARY KEY COMMENT '药品编号',
    medicine_name VARCHAR(100) NOT NULL COMMENT '药品名称',
    generic_name VARCHAR(100) COMMENT '通用名',
    dosage_form VARCHAR(50) COMMENT '剂型',
    specification VARCHAR(50) COMMENT '规格',
    manufacturer VARCHAR(100) COMMENT '生产厂家',
    unit_price DECIMAL(10,2) NOT NULL COMMENT '单价',
    stock_quantity INT DEFAULT 0 COMMENT '库存数量',
    min_stock INT DEFAULT 100 COMMENT '最低库存',
    expiry_date DATE COMMENT '有效期',
    category VARCHAR(50) COMMENT '药品分类',
    prescription_required BOOLEAN DEFAULT TRUE COMMENT '是否需要处方',
    description TEXT COMMENT '药品说明',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_medicine_name (medicine_name),
    INDEX idx_category (category),
    CHECK (stock_quantity >= 0)
) ENGINE=InnoDB COMMENT='药品信息表';


-- 8. 处方表（Prescription）

CREATE TABLE prescription (
    prescription_id VARCHAR(30) PRIMARY KEY COMMENT '处方编号',
    diagnosis_id VARCHAR(30) NOT NULL COMMENT '诊断编号',
    patient_id VARCHAR(20) NOT NULL COMMENT '患者编号',
    doctor_id VARCHAR(20) NOT NULL COMMENT '医生工号',
    prescription_date DATETIME NOT NULL COMMENT '开方时间',
    total_amount DECIMAL(10,2) DEFAULT 0 COMMENT '处方总金额',
    status ENUM('未付费', '已付费', '已取药', '已作废') DEFAULT '未付费' COMMENT '状态',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (diagnosis_id) REFERENCES diagnosis(diagnosis_id) ON DELETE RESTRICT,
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id) ON DELETE RESTRICT,
    FOREIGN KEY (doctor_id) REFERENCES doctor(doctor_id) ON DELETE RESTRICT,
    INDEX idx_patient_id (patient_id),
    INDEX idx_doctor_id (doctor_id),
    INDEX idx_status (status)
) ENGINE=InnoDB COMMENT='处方表';



-- 9. 处方明细表（Prescription_Detail）

CREATE TABLE prescription_detail (
    detail_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '明细ID',
    prescription_id VARCHAR(30) NOT NULL COMMENT '处方编号',
    medicine_id VARCHAR(20) NOT NULL COMMENT '药品编号',
    quantity INT NOT NULL COMMENT '数量',
    unit_price DECIMAL(10,2) NOT NULL COMMENT '单价',
    dosage VARCHAR(100) COMMENT '用法用量',
    frequency VARCHAR(50) COMMENT '用药频率',
    duration VARCHAR(50) COMMENT '用药时长',
    subtotal DECIMAL(10,2) AS (quantity * unit_price) STORED COMMENT '小计',
    FOREIGN KEY (prescription_id) REFERENCES prescription(prescription_id) ON DELETE CASCADE,
    FOREIGN KEY (medicine_id) REFERENCES medicine(medicine_id) ON DELETE RESTRICT,
    INDEX idx_prescription_id (prescription_id),
    INDEX idx_medicine_id (medicine_id),
    CHECK (quantity > 0)
) ENGINE=InnoDB COMMENT='处方明细表';



-- 10. 检查项目表（Examination）

CREATE TABLE examination (
    exam_id VARCHAR(20) PRIMARY KEY COMMENT '检查项目编号',
    exam_name VARCHAR(100) NOT NULL COMMENT '检查项目名称',
    category VARCHAR(50) COMMENT '检查类别',
    price DECIMAL(10,2) NOT NULL COMMENT '价格',
    description TEXT COMMENT '项目说明',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_exam_name (exam_name),
    INDEX idx_category (category)
) ENGINE=InnoDB COMMENT='检查项目表';


-- 11. 检查记录表（Examination_Record）

CREATE TABLE examination_record (
    record_id VARCHAR(30) PRIMARY KEY COMMENT '检查记录编号',
    diagnosis_id VARCHAR(30) NOT NULL COMMENT '诊断编号',
    patient_id VARCHAR(20) NOT NULL COMMENT '患者编号',
    exam_id VARCHAR(20) NOT NULL COMMENT '检查项目编号',
    exam_date DATETIME COMMENT '检查时间',
    result TEXT COMMENT '检查结果',
    conclusion TEXT COMMENT '检查结论',
    examiner VARCHAR(50) COMMENT '检查医生',
    status ENUM('待检查', '已完成', '已取消') DEFAULT '待检查' COMMENT '状态',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (diagnosis_id) REFERENCES diagnosis(diagnosis_id) ON DELETE RESTRICT,
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id) ON DELETE RESTRICT,
    FOREIGN KEY (exam_id) REFERENCES examination(exam_id) ON DELETE RESTRICT,
    INDEX idx_patient_id (patient_id),
    INDEX idx_exam_date (exam_date)
) ENGINE=InnoDB COMMENT='检查记录表';


-- 12. 收费记录表（Payment）

CREATE TABLE payment (
    payment_id VARCHAR(30) PRIMARY KEY COMMENT '收费编号',
    patient_id VARCHAR(20) NOT NULL COMMENT '患者编号',
    payment_type ENUM('挂号费', '诊疗费', '药品费', '检查费', '其他') NOT NULL COMMENT '收费类型',
    amount DECIMAL(10,2) NOT NULL COMMENT '金额',
    payment_method ENUM('现金', '支付宝', '微信', '银行卡', '医保') NOT NULL COMMENT '支付方式',
    payment_date DATETIME NOT NULL COMMENT '收费时间',
    cashier VARCHAR(50) COMMENT '收费员',
    related_id VARCHAR(30) COMMENT '关联单据号',
    invoice_no VARCHAR(30) COMMENT '发票号',
    status ENUM('已收费', '已退费') DEFAULT '已收费' COMMENT '状态',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id) ON DELETE RESTRICT,
    INDEX idx_patient_id (patient_id),
    INDEX idx_payment_date (payment_date),
    INDEX idx_payment_type (payment_type)
) ENGINE=InnoDB COMMENT='收费记录表';


-- 13. 用户表（User）- 系统用户

CREATE TABLE system_user (
    user_id VARCHAR(20) PRIMARY KEY COMMENT '用户ID',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password_hash VARCHAR(255) NOT NULL COMMENT '密码哈希',
    real_name VARCHAR(50) NOT NULL COMMENT '真实姓名',
    role ENUM('管理员', '医生', '护士', '药师', '收费员') NOT NULL COMMENT '角色',
    related_id VARCHAR(20) COMMENT '关联ID（如医生工号）',
    email VARCHAR(100) COMMENT '邮箱',
    phone VARCHAR(20) COMMENT '电话',
    status ENUM('启用', '禁用') DEFAULT '启用' COMMENT '状态',
    last_login DATETIME COMMENT '最后登录时间',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_role (role)
) ENGINE=InnoDB COMMENT='系统用户表';

-- 创建视图


-- 1. 医生工作量统计视图
DROP VIEW IF EXISTS v_doctor_workload;
CREATE VIEW v_doctor_workload AS
SELECT 
    d.doctor_id,
    d.doctor_name,
    dept.dept_name,
    d.title,
    COUNT(DISTINCT a.appointment_id) AS total_appointments,
    COUNT(DISTINCT CASE WHEN a.status = '已就诊' THEN a.appointment_id END) AS completed_appointments,
    COUNT(DISTINCT dia.diagnosis_id) AS total_diagnoses,
    COALESCE(SUM(p. ), 0) AS total_prescription_amount
FROM 
    doctor d
LEFT JOIN 
    department dept ON d.dept_id = dept.dept_id
LEFT JOIN 
    appointment a ON d.doctor_id = a.doctor_id
LEFT JOIN 
    diagnosis dia ON d.doctor_id = dia.doctor_id
LEFT JOIN 
    prescription p ON dia.diagnosis_id = p.diagnosis_id
GROUP BY 
    d.doctor_id, d.doctor_name, dept.dept_name, d.title;

-- 2. 患者就诊历史视图
DROP VIEW IF EXISTS v_patient_visit_history;
CREATE VIEW v_patient_visit_history AS
SELECT 
    p.patient_id,
    p.patient_name,
    p.gender,
    TIMESTAMPDIFF(YEAR, p.birth_date, CURDATE()) AS age,
    a.appointment_id,
    a.appointment_date,
    a.time_slot,
    d.doctor_name,
    dept.dept_name,
    dia.diagnosis_result,
    a.status AS appointment_status
FROM 
    patient p
LEFT JOIN 
    appointment a ON p.patient_id = a.patient_id
LEFT JOIN 
    doctor d ON a.doctor_id = d.doctor_id
LEFT JOIN 
    department dept ON d.dept_id = dept.dept_id
LEFT JOIN 
    diagnosis dia ON a.appointment_id = dia.appointment_id;

-- 3. 药品库存预警视图
DROP VIEW IF EXISTS v_medicine_stock_alert;
CREATE VIEW v_medicine_stock_alert AS
SELECT 
    medicine_id,
    medicine_name,
    specification,
    stock_quantity,
    min_stock,
    (stock_quantity - min_stock) AS stock_diff,
    CASE 
        WHEN stock_quantity <= 0 THEN '缺货'
        WHEN stock_quantity <= min_stock THEN '库存不足'
        WHEN stock_quantity <= min_stock * 1.5 THEN '库存偏低'
        ELSE '库存正常'
    END AS stock_status,
    expiry_date,
    DATEDIFF(expiry_date, CURDATE()) AS days_to_expiry,
    CASE 
        WHEN DATEDIFF(expiry_date, CURDATE()) <= 30 THEN '即将过期'
        WHEN DATEDIFF(expiry_date, CURDATE()) <= 90 THEN '临近过期'
        ELSE '正常'
    END AS expiry_status
FROM 
    medicine
ORDER BY 
    stock_quantity ASC;

-- 4. 科室收入统计视图
DROP VIEW IF EXISTS v_department_revenue;
CREATE VIEW v_department_revenue AS
SELECT 
    dept.dept_id,
    dept.dept_name,
    DATE_FORMAT(pay.payment_date, '%Y-%m') AS month,
    COUNT(DISTINCT a.appointment_id) AS total_appointments,
    SUM(CASE WHEN pay.payment_type = '挂号费' THEN pay.amount ELSE 0 END) AS registration_revenue,
    SUM(CASE WHEN pay.payment_type = '药品费' THEN pay.amount ELSE 0 END) AS medicine_revenue,
    SUM(CASE WHEN pay.payment_type = '检查费' THEN pay.amount ELSE 0 END) AS examination_revenue,
    SUM(pay.amount) AS total_revenue
FROM 
    department dept
LEFT JOIN 
    doctor d ON dept.dept_id = d.dept_id
LEFT JOIN 
    appointment a ON d.doctor_id = a.doctor_id
LEFT JOIN 
    payment pay ON a.patient_id = pay.patient_id
WHERE 
    pay.status = '已收费'
GROUP BY 
    dept.dept_id, dept.dept_name, DATE_FORMAT(pay.payment_date, '%Y-%m');

-- 5. 每日预约统计视图
DROP VIEW IF EXISTS v_daily_appointment_stats;
CREATE VIEW v_daily_appointment_stats AS
SELECT 
    a.appointment_date,
    dept.dept_name,
    COUNT(*) AS total_appointments,
    SUM(CASE WHEN a.status = '已预约' THEN 1 ELSE 0 END) AS pending,
    SUM(CASE WHEN a.status = '已就诊' THEN 1 ELSE 0 END) AS completed,
    SUM(CASE WHEN a.status = '已取消' THEN 1 ELSE 0 END) AS cancelled,
    SUM(CASE WHEN a.status = '爽约' THEN 1 ELSE 0 END) AS no_show,
    ROUND(SUM(CASE WHEN a.status = '已就诊' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS completion_rate
FROM 
    appointment a
JOIN 
    doctor d ON a.doctor_id = d.doctor_id
JOIN 
    department dept ON d.dept_id = dept.dept_id
GROUP BY 
    a.appointment_date, dept.dept_name;


-- 创建额外的索引优化查询性能

-- 预约表的复合索引
CREATE INDEX idx_appointment_patient_date ON appointment(patient_id, appointment_date);
CREATE INDEX idx_appointment_doctor_date ON appointment(doctor_id, appointment_date);

-- 诊断表的复合索引
CREATE INDEX idx_diagnosis_patient_date ON diagnosis(patient_id, diagnosis_date);
CREATE INDEX idx_diagnosis_doctor_date ON diagnosis(doctor_id, diagnosis_date);

-- 处方表的复合索引
CREATE INDEX idx_prescription_patient_status ON prescription(patient_id, status);

-- 收费表的复合索引
CREATE INDEX idx_payment_patient_date ON payment(patient_id, payment_date);
CREATE INDEX idx_payment_date_type ON payment(payment_date, payment_type);

-- 药品表的库存索引
CREATE INDEX idx_medicine_stock ON medicine(stock_quantity);

-- 检查记录表的日期索引
CREATE INDEX idx_exam_record_date ON examination_record(exam_date);

-- 插入测试数据


-- 1. 科室数据
INSERT INTO department (dept_id, dept_name, location, phone, description) VALUES
('D001', '心内科', '门诊楼3楼', '024-12345001', '擅长心血管疾病诊治'),
('D002', '呼吸科', '门诊楼3楼', '024-12345002', '擅长呼吸系统疾病诊治'),
('D003', '消化科', '门诊楼4楼', '024-12345003', '擅长消化系统疾病诊治'),
('D004', '神经内科', '门诊楼4楼', '024-12345004', '擅长神经系统疾病诊治'),
('D005', '骨科', '门诊楼5楼', '024-12345005', '擅长骨科疾病诊治'),
('D006', '儿科', '门诊楼2楼', '024-12345006', '擅长儿童疾病诊治'),
('D007', '妇产科', '门诊楼2楼', '024-12345007', '擅长妇产科疾病诊治'),
('D008', '眼科', '门诊楼6楼', '024-12345008', '擅长眼科疾病诊治');

-- 2. 医生数据
INSERT INTO doctor (doctor_id, doctor_name, gender, birth_date, phone, email, dept_id, title, specialty, registration_fee, status) VALUES
('DOC001', '张伟', 'M', '1975-03-15', '13800138001', 'zhangwei@hospital.com', 'D001', '主任医师', '冠心病、高血压', 50.00, '在职'),
('DOC002', '李娜', 'F', '1980-07-20', '13800138002', 'lina@hospital.com', 'D001', '副主任医师', '心律失常、心力衰竭', 30.00, '在职'),
('DOC003', '王强', 'M', '1982-05-10', '13800138003', 'wangqiang@hospital.com', 'D002', '主治医师', '哮喘、慢阻肺', 20.00, '在职'),
('DOC004', '刘芳', 'F', '1978-11-25', '13800138004', 'liufang@hospital.com', 'D003', '主任医师', '胃肠疾病、肝病', 50.00, '在职'),
('DOC005', '陈明', 'M', '1985-09-08', '13800138005', 'chenming@hospital.com', 'D004', '副主任医师', '脑血管病、癫痫', 30.00, '在职'),
('DOC006', '赵丽', 'F', '1983-02-14', '13800138006', 'zhaoli@hospital.com', 'D005', '主治医师', '骨折、关节疾病', 20.00, '在职'),
('DOC007', '孙梅', 'F', '1976-12-30', '13800138007', 'sunmei@hospital.com', 'D006', '主任医师', '儿童呼吸、消化系统疾病', 50.00, '在职'),
('DOC008', '周杰', 'M', '1981-06-18', '13800138008', 'zhoujie@hospital.com', 'D007', '副主任医师', '产科、妇科疾病', 30.00, '在职');

-- 3. 患者数据
INSERT INTO patient (patient_id, patient_name, gender, birth_date, id_card, phone, address, emergency_contact, emergency_phone, blood_type, allergy_history) VALUES
('P00001', '张三', 'M', '1990-05-20', '210101199005201234', '13900139001', '沈阳市和平区XX路XX号', '李四', '13900139002', 'A', '青霉素过敏'),
('P00002', '李四', 'F', '1985-08-15', '210101198508151234', '13900139003', '沈阳市沈河区XX路XX号', '王五', '13900139004', 'B', '无'),
('P00003', '王五', 'M', '2000-03-10', '210101200003101234', '13900139005', '沈阳市大东区XX路XX号', '赵六', '13900139006', 'O', '磺胺类过敏'),
('P00004', '赵六', 'F', '1978-11-25', '210101197811251234', '13900139007', '沈阳市皇姑区XX路XX号', '孙七', '13900139008', 'AB', '无'),
('P00005', '孙七', 'M', '1965-02-14', '210101196502141234', '13900139009', '沈阳市铁西区XX路XX号', '周八', '13900139010', 'A', '头孢过敏');

-- 4. 医生排班数据
INSERT INTO doctor_schedule (doctor_id, work_date, time_slot, max_appointments, booked_count, status) VALUES
('DOC001', '2024-12-18', '上午', 30, 0, '正常'),
('DOC001', '2024-12-18', '下午', 30, 0, '正常'),
('DOC001', '2024-12-19', '上午', 30, 0, '正常'),
('DOC002', '2024-12-18', '上午', 25, 0, '正常'),
('DOC002', '2024-12-18', '下午', 25, 0, '正常'),
('DOC003', '2024-12-18', '上午', 20, 0, '正常'),
('DOC004', '2024-12-18', '下午', 30, 0, '正常'),
('DOC005', '2024-12-19', '上午', 25, 0, '正常');

-- 5. 药品数据
INSERT INTO medicine (medicine_id, medicine_name, generic_name, dosage_form, specification, manufacturer, unit_price, stock_quantity, min_stock, expiry_date, category, prescription_required) VALUES
('M001', '阿莫西林胶囊', '阿莫西林', '胶囊', '0.25g*24粒', 'XX制药有限公司', 15.50, 500, 100, '2025-12-31', '抗生素', TRUE),
('M002', '头孢克肟片', '头孢克肟', '片剂', '0.1g*12片', 'XX制药有限公司', 25.80, 300, 100, '2025-12-31', '抗生素', TRUE),
('M003', '布洛芬缓释胶囊', '布洛芬', '缓释胶囊', '0.3g*20粒', 'XX制药有限公司', 12.00, 600, 100, '2025-12-31', '解热镇痛', FALSE),
('M004', '对乙酰氨基酚片', '对乙酰氨基酚', '片剂', '0.5g*12片', 'XX制药有限公司', 8.50, 800, 100, '2025-12-31', '解热镇痛', FALSE),
('M005', '奥美拉唑肠溶胶囊', '奥美拉唑', '肠溶胶囊', '20mg*14粒', 'XX制药有限公司', 18.60, 400, 100, '2025-12-31', '消化系统', TRUE),
('M006', '蒙脱石散', '蒙脱石', '散剂', '3g*10袋', 'XX制药有限公司', 22.00, 350, 100, '2025-12-31', '消化系统', FALSE),
('M007', '硝苯地平缓释片', '硝苯地平', '缓释片', '20mg*30片', 'XX制药有限公司', 35.00, 200, 50, '2025-12-31', '心血管系统', TRUE),
('M008', '阿托伐他汀钙片', '阿托伐他汀钙', '片剂', '20mg*7片', 'XX制药有限公司', 45.00, 250, 50, '2025-12-31', '心血管系统', TRUE);

-- 6. 检查项目数据
INSERT INTO examination (exam_id, exam_name, category, price, description) VALUES
('E001', '血常规', '化验检查', 20.00, '检查血液中各种细胞成分'),
('E002', '尿常规', '化验检查', 15.00, '检查尿液中各种成分'),
('E003', '肝功能', '化验检查', 80.00, '检查肝脏功能指标'),
('E004', '心电图', '功能检查', 30.00, '检查心脏电活动'),
('E005', '胸部X线', '影像检查', 60.00, '胸部X线摄片检查'),
('E006', 'B超检查', '影像检查', 100.00, 'B超影像检查'),
('E007', 'CT检查', '影像检查', 300.00, 'CT影像检查'),
('E008', 'MRI检查', '影像检查', 800.00, 'MRI影像检查');

-- 7. 系统用户数据
INSERT INTO system_user (user_id, username, password_hash, real_name, role, related_id, email, phone, status) VALUES
('U001', 'admin', MD5('admin123'), '系统管理员', '管理员', NULL, 'admin@hospital.com', '13800000001', '启用'),
('U002', 'doc001', MD5('doc123'), '张伟', '医生', 'DOC001', 'zhangwei@hospital.com', '13800138001', '启用'),
('U003', 'doc002', MD5('doc123'), '李娜', '医生', 'DOC002', 'lina@hospital.com', '13800138002', '启用'),
('U004', 'nurse001', MD5('nurse123'), '护士小王', '护士', NULL, 'nurse001@hospital.com', '13800000002', '启用'),
('U005', 'cashier001', MD5('cash123'), '收费员小李', '收费员', NULL, 'cashier001@hospital.com', '13800000003', '启用');

-- 添加预约挂号数据
INSERT INTO appointment (appointment_id, patient_id, doctor_id, schedule_id, appointment_date, time_slot, queue_number, status, registration_fee, created_at) VALUES
-- 2024-12-18 的预约
('APT2024121800001', 'P00001', 'DOC001', 1, '2024-12-18', '上午', 1, '已就诊', 50.00, '2024-12-17 08:30:00'),
('APT2024121800002', 'P00002', 'DOC001', 1, '2024-12-18', '上午', 2, '已就诊', 50.00, '2024-12-17 09:15:00'),
('APT2024121800003', 'P00003', 'DOC001', 1, '2024-12-18', '上午', 3, '已预约', 50.00, '2024-12-17 10:20:00'),
('APT2024121800004', 'P00004', 'DOC001', 2, '2024-12-18', '下午', 1, '已就诊', 50.00, '2024-12-17 14:30:00'),
('APT2024121800005', 'P00005', 'DOC001', 2, '2024-12-18', '下午', 2, '已取消', 50.00, '2024-12-17 15:45:00'),

('APT2024121800006', 'P00001', 'DOC002', 4, '2024-12-18', '上午', 1, '已就诊', 30.00, '2024-12-17 08:45:00'),
('APT2024121800007', 'P00002', 'DOC002', 5, '2024-12-18', '下午', 1, '已预约', 30.00, '2024-12-17 11:20:00'),
('APT2024121800008', 'P00003', 'DOC002', 5, '2024-12-18', '下午', 2, '爽约', 30.00, '2024-12-17 13:30:00'),

('APT2024121800009', 'P00004', 'DOC003', 6, '2024-12-18', '上午', 1, '已就诊', 20.00, '2024-12-17 09:00:00'),
('APT2024121800010', 'P00005', 'DOC003', 6, '2024-12-18', '上午', 2, '已就诊', 20.00, '2024-12-17 10:30:00'),

('APT2024121800011', 'P00001', 'DOC004', 7, '2024-12-18', '下午', 1, '已就诊', 50.00, '2024-12-17 14:00:00'),
('APT2024121800012', 'P00002', 'DOC004', 7, '2024-12-18', '下午', 2, '已预约', 50.00, '2024-12-17 15:00:00'),

-- 2024-12-19 的预约
('APT2024121900001', 'P00003', 'DOC001', 3, '2024-12-19', '上午', 1, '已预约', 50.00, '2024-12-18 08:30:00'),
('APT2024121900002', 'P00004', 'DOC001', 3, '2024-12-19', '上午', 2, '已预约', 50.00, '2024-12-18 09:00:00'),
('APT2024121900003', 'P00005', 'DOC001', 3, '2024-12-19', '上午', 3, '已预约', 50.00, '2024-12-18 10:15:00'),

('APT2024121900004', 'P00001', 'DOC005', 8, '2024-12-19', '上午', 1, '已预约', 30.00, '2024-12-18 08:45:00'),
('APT2024121900005', 'P00002', 'DOC005', 8, '2024-12-19', '上午', 2, '已预约', 30.00, '2024-12-18 11:20:00');
-- 更新排班表的已预约数
UPDATE doctor_schedule SET booked_count = 3 WHERE schedule_id = 1;  -- DOC001 12-18上午
UPDATE doctor_schedule SET booked_count = 2 WHERE schedule_id = 2;  -- DOC001 12-18下午
UPDATE doctor_schedule SET booked_count = 3 WHERE schedule_id = 3;  -- DOC001 12-19上午
UPDATE doctor_schedule SET booked_count = 1 WHERE schedule_id = 4;  -- DOC002 12-18上午
UPDATE doctor_schedule SET booked_count = 2 WHERE schedule_id = 5;  -- DOC002 12-18下午
UPDATE doctor_schedule SET booked_count = 2 WHERE schedule_id = 6;  -- DOC003 12-18上午
UPDATE doctor_schedule SET booked_count = 2 WHERE schedule_id = 7;  -- DOC004 12-18下午
UPDATE doctor_schedule SET booked_count = 2 WHERE schedule_id = 8;  -- DOC005 12-19上午
-- 插入收费记录数据
INSERT INTO payment (payment_id, patient_id, payment_type, amount, payment_method, payment_date, cashier, related_id, invoice_no, status) VALUES
-- 2024-12-18 的收费记录

-- P00001 的收费记录（心内科 张伟 主任医师）
('PAY2024121800001', 'P00001', '挂号费', 50.00, '微信', '2024-12-18 08:30:00', '收费员小李', 'APT2024121800001', 'INV2024121800001', '已收费'),
('PAY2024121800002', 'P00001', '检查费', 20.00, '微信', '2024-12-18 09:15:00', '收费员小李', 'E001', 'INV2024121800002', '已收费'),
('PAY2024121800003', 'P00001', '检查费', 30.00, '微信', '2024-12-18 09:20:00', '收费员小李', 'E004', 'INV2024121800003', '已收费'),
('PAY2024121800004', 'P00001', '药品费', 80.60, '微信', '2024-12-18 10:00:00', '收费员小李', 'PRES001', 'INV2024121800004', '已收费'),

-- P00002 的收费记录（心内科 张伟 主任医师）
('PAY2024121800005', 'P00002', '挂号费', 50.00, '支付宝', '2024-12-18 08:35:00', '收费员小李', 'APT2024121800002', 'INV2024121800005', '已收费'),
('PAY2024121800006', 'P00002', '检查费', 20.00, '支付宝', '2024-12-18 09:30:00', '收费员小李', 'E001', 'INV2024121800006', '已收费'),
('PAY2024121800007', 'P00002', '药品费', 45.00, '支付宝', '2024-12-18 10:15:00', '收费员小李', 'PRES002', 'INV2024121800007', '已收费'),

-- P00004 的收费记录（心内科 张伟 主任医师 下午）
('PAY2024121800008', 'P00004', '挂号费', 50.00, '医保', '2024-12-18 14:30:00', '收费员小李', 'APT2024121800004', 'INV2024121800008', '已收费'),
('PAY2024121800009', 'P00004', '检查费', 80.00, '医保', '2024-12-18 15:00:00', '收费员小李', 'E003', 'INV2024121800009', '已收费'),
('PAY2024121800010', 'P00004', '药品费', 63.60, '医保', '2024-12-18 15:45:00', '收费员小李', 'PRES003', 'INV2024121800010', '已收费'),

-- P00001 的收费记录（心内科 李娜 副主任医师）
('PAY2024121800011', 'P00001', '挂号费', 30.00, '微信', '2024-12-18 08:45:00', '收费员小李', 'APT2024121800006', 'INV2024121800011', '已收费'),
('PAY2024121800012', 'P00001', '检查费', 30.00, '微信', '2024-12-18 09:30:00', '收费员小李', 'E004', 'INV2024121800012', '已收费'),
('PAY2024121800013', 'P00001', '药品费', 35.00, '微信', '2024-12-18 10:15:00', '收费员小李', 'PRES004', 'INV2024121800013', '已收费'),

-- P00004 的收费记录（呼吸科 王强 主治医师）
('PAY2024121800014', 'P00004', '挂号费', 20.00, '现金', '2024-12-18 09:00:00', '收费员小李', 'APT2024121800009', 'INV2024121800014', '已收费'),
('PAY2024121800015', 'P00004', '检查费', 20.00, '现金', '2024-12-18 09:45:00', '收费员小李', 'E001', 'INV2024121800015', '已收费'),
('PAY2024121800016', 'P00004', '检查费', 60.00, '现金', '2024-12-18 10:00:00', '收费员小李', 'E005', 'INV2024121800016', '已收费'),
('PAY2024121800017', 'P00004', '药品费', 47.80, '现金', '2024-12-18 11:00:00', '收费员小李', 'PRES005', 'INV2024121800017', '已收费'),

-- P00005 的收费记录（呼吸科 王强 主治医师）
('PAY2024121800018', 'P00005', '挂号费', 20.00, '银行卡', '2024-12-18 09:05:00', '收费员小李', 'APT2024121800010', 'INV2024121800018', '已收费'),
('PAY2024121800019', 'P00005', '检查费', 20.00, '银行卡', '2024-12-18 10:00:00', '收费员小李', 'E001', 'INV2024121800019', '已收费'),
('PAY2024121800020', 'P00005', '药品费', 40.60, '银行卡', '2024-12-18 10:45:00', '收费员小李', 'PRES006', 'INV2024121800020', '已收费'),

-- P00001 的收费记录（消化科 刘芳 主任医师）
('PAY2024121800021', 'P00001', '挂号费', 50.00, '微信', '2024-12-18 14:00:00', '收费员小李', 'APT2024121800011', 'INV2024121800021', '已收费'),
('PAY2024121800022', 'P00001', '检查费', 15.00, '微信', '2024-12-18 14:45:00', '收费员小李', 'E002', 'INV2024121800022', '已收费'),
('PAY2024121800023', 'P00001', '检查费', 100.00, '微信', '2024-12-18 15:00:00', '收费员小李', 'E006', 'INV2024121800023', '已收费'),
('PAY2024121800024', 'P00001', '药品费', 40.60, '微信', '2024-12-18 16:00:00', '收费员小李', 'PRES007', 'INV2024121800024', '已收费'),

-- 2024-12-17 的历史收费记录（补充数据）
('PAY2024121700001', 'P00003', '挂号费', 30.00, '支付宝', '2024-12-17 08:30:00', '收费员小李', 'APT2024121700001', 'INV2024121700001', '已收费'),
('PAY2024121700002', 'P00003', '检查费', 20.00, '支付宝', '2024-12-17 09:15:00', '收费员小李', 'E001', 'INV2024121700002', '已收费'),
('PAY2024121700003', 'P00003', '药品费', 37.50, '支付宝', '2024-12-17 10:00:00', '收费员小李', 'PRES008', 'INV2024121700003', '已收费'),

('PAY2024121700004', 'P00004', '挂号费', 50.00, '医保', '2024-12-17 09:00:00', '收费员小李', 'APT2024121700002', 'INV2024121700004', '已收费'),
('PAY2024121700005', 'P00004', '检查费', 80.00, '医保', '2024-12-17 10:00:00', '收费员小李', 'E003', 'INV2024121700005', '已收费'),
('PAY2024121700006', 'P00004', '药品费', 90.00, '医保', '2024-12-17 11:00:00', '收费员小李', 'PRES009', 'INV2024121700006', '已收费'),

-- 退费记录示例
('PAY2024121800025', 'P00005', '挂号费', -50.00, '现金', '2024-12-18 16:30:00', '收费员小李', 'APT2024121800005', 'INV2024121800025', '已退费');

-- 患者挂号流程演示
-- 1.1 查询可预约的医生排班
SELECT 
    ds.schedule_id,
    d.doctor_name,
    dept.dept_name,
    d.title,
    ds.work_date,
    ds.time_slot,
    ds.max_appointments,
    ds.booked_count,
    (ds.max_appointments - ds.booked_count) AS available_slots,
    d.registration_fee
FROM doctor_schedule ds
JOIN doctor d ON ds.doctor_id = d.doctor_id
JOIN department dept ON d.dept_id = dept.dept_id
WHERE ds.work_date = '2024-12-19'
  AND ds.status = '正常'
  AND ds.booked_count < ds.max_appointments
ORDER BY dept.dept_name, ds.time_slot;

-- 1.2 创建预约挂号
INSERT INTO appointment (appointment_id, patient_id, doctor_id, schedule_id, appointment_date, time_slot, queue_number, status, registration_fee) 
VALUES ('APT2024121900007', 'P00004', 'DOC003', 8, '2024-12-19', '上午', 3, '已预约', 30.00);

-- 1.3 更新排班已预约数
UPDATE doctor_schedule SET booked_count = booked_count + 1 WHERE schedule_id = 8;

-- 1.4 收取挂号费
INSERT INTO payment (payment_id, patient_id, payment_type, amount, payment_method, payment_date, cashier, related_id, invoice_no, status)
VALUES ('PAY2024121900007', 'P00004', '挂号费', 30.00, '微信', NOW(), '收费员小李', 'APT2024121900006', 'INV2024121900001', '已收费');

-- 医生接诊流程演示
-- 2.1 查看今日待诊患者
SELECT 
    a.queue_number,
    p.patient_name,
    p.gender,
    TIMESTAMPDIFF(YEAR, p.birth_date, CURDATE()) AS age,
    p.phone,
    a.appointment_id,
    a.time_slot
FROM appointment a
JOIN patient p ON a.patient_id = p.patient_id
WHERE a.doctor_id = 'DOC001'
  AND a.appointment_date = '2024-12-18'
  AND a.status = '已预约'
ORDER BY a.queue_number;

-- 2.2 创建诊断记录
INSERT INTO diagnosis (diagnosis_id, appointment_id, patient_id, doctor_id, diagnosis_date, chief_complaint, present_illness, physical_exam, diagnosis_result, treatment_plan, doctor_advice)
VALUES ('DIAG2024121800001', 'APT2024121800001', 'P00001', 'DOC001', '2024-12-18 09:00:00', 
        '胸闷气短3天', '患者3天前无明显诱因出现胸闷气短，活动后加重', 
        '血压150/95mmHg，心率85次/分，律齐', '高血压病2级，冠心病', 
        '1.降压治疗 2.改善心肌供血', '注意休息，低盐饮食，定期复查');

-- 2.3 开具处方
INSERT INTO prescription (prescription_id, diagnosis_id, patient_id, doctor_id, prescription_date, total_amount, status)
VALUES ('PRES2024121800001', 'DIAG2024121800001', 'P00001', 'DOC001', '2024-12-18 09:15:00', 80.60, '未付费');

-- 2.4 添加处方明细
INSERT INTO prescription_detail (prescription_id, medicine_id, quantity, unit_price, dosage, frequency, duration) VALUES
('PRES2024121800001', 'M007', 2, 35.00, '每次1片', '每日1次', '30天'),
('PRES2024121800001', 'M001', 1, 15.50, '每次2粒', '每日3次', '7天');

-- 2.5 更新处方总金额
UPDATE prescription SET total_amount = (SELECT SUM(subtotal) FROM prescription_detail WHERE prescription_id = 'PRES2024121800001') 
WHERE prescription_id = 'PRES2024121800001';

-- 2.6 开具检查单
INSERT INTO examination_record (record_id, diagnosis_id, patient_id, exam_id, status)
VALUES ('ER2024121800001', 'DIAG2024121800001', 'P00001', 'E001', '待检查'),
       ('ER2024121800002', 'DIAG2024121800001', 'P00001', 'E004', '待检查');

-- 2.7 更新预约状态为已就诊
UPDATE appointment SET status = '已就诊' WHERE appointment_id = 'APT2024121800001';

-- 患者缴费取药流程
-- 3.1 查询待缴费项目
SELECT 
    '处方' AS type,
    p.prescription_id AS id,
    p.total_amount AS amount,
    p.prescription_date AS date,
    '未付费' AS status
FROM prescription p
WHERE p.patient_id = 'P00001' AND p.status = '未付费'
UNION ALL
SELECT 
    '检查' AS type,
    er.record_id AS id,
    e.price AS amount,
    er.created_at AS date,
    er.status
FROM examination_record er
JOIN examination e ON er.exam_id = e.exam_id
WHERE er.patient_id = 'P00001' AND er.status = '待检查';

-- 3.2 收取药品费
INSERT INTO payment (payment_id, patient_id, payment_type, amount, payment_method, payment_date, cashier, related_id, invoice_no, status)
VALUES ('PAY2024121800026', 'P00001', '药品费', 80.60, '微信', NOW(), '收费员小李', 'PRES2024121800001', 'INV2024121800026', '已收费');

-- 3.3 更新处方状态
UPDATE prescription SET status = '已付费' WHERE prescription_id = 'PRES2024121800001';

-- 3.4 更新药品库存
UPDATE medicine SET stock_quantity = stock_quantity - 2 WHERE medicine_id = 'M007';
UPDATE medicine SET stock_quantity = stock_quantity - 1 WHERE medicine_id = 'M001';

-- 3.5 患者取药后更新处方状态
UPDATE prescription SET status = '已取药' WHERE prescription_id = 'PRES2024121800001';

