cls
import pdfplumber
import re
import os 

def parse_resume(file_path):
    text = ""

    if not os.path.exists(file_path):  # Fix typo
        return {"error": f"❌ File not found: {file_path}"}
    
    with pdfplumber.open(file_path) as pdf:  # Fix indentation
        for page in pdf.pages:
            text += page.extract_text() or ""

    resume_data = {
        "name": text.split('\n')[0].strip() if text.split('\n') else None,
        "email": next((e for e in re.findall(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}', text)), None),
        "phone": next((p for p in re.findall(r'\b\d{10}\b|\+91-\d{10}', text)), None),  # Fix 'none' to 'None'
        "skills": [],
        "experience": []
    }

    # ✅ Skills
    skills_list = ["python", "nlp", "ai"]  # Make skills list lowercase
    for word in re.findall(r'\b\w+\b', text.lower()):
        if word in skills_list and word not in resume_data["skills"]:
            resume_data["skills"].append(word)

    # ✅ Experience
    for line in text.split('\n'):
        if "experience" in line.lower() or "worked" in line.lower():
            resume_data["experience"].append(line.strip())

    return resume_data

# ✅ Replace with your actual PDF path
file_path = "sample_resume.pdf"
result = parse_resume(file_path)

print("Extracted Data:")
for key, value in result.items():
    print(f"{key.capitalize()}: {value}")                    
:End
