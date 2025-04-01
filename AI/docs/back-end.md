# Student Mobile Application - API Documentation

## API Overview
This document details the backend API endpoints used by the Student Mobile Application to retrieve and manage student academic information. All endpoints require proper authentication and handle data in JSON format.

## Base URL
```
https://progres.mesrs.dz/api/
```

## Authentication

### Login Endpoint
Authenticates a student and returns a session token and necessary identifiers.

- **Endpoint:** `/authentication/v1/`
- **Method:** `POST`
- **Content-Type:** `application/json`

#### Request Body
```json
{
    "username": "1929192192", 
    "password": "password"
}
```

#### Response (200 OK)
```json
{
    "expirationDate": "2025-04-30T16:55:28.555+00:00",
    "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...[truncated]",
    "userId": 122212,
    "uuid": "0f5b98ee-2428-4d42-aafd-23232323",
    "idIndividu": 121212,
    "etablissementId": 121212,
    "userName": "20201012992"
}
```

#### Response Fields
| Field | Type | Description |
|-------|------|-------------|
| expirationDate | string | JWT token expiration date in ISO format |
| token | string | JWT authentication token for subsequent requests |
| userId | number | Unique identifier for the student account |
| uuid | string | UUID used in API requests |
| idIndividu | number | Individual identifier |
| etablissementId | number | Institution identifier |
| userName | string | Student username (usually student code) |

#### Error Responses
- **401 Unauthorized**: Invalid credentials
- **400 Bad Request**: Malformed request
- **500 Server Error**: Server-side processing error

## Data Retrieval

### 1. Student Basic Information
Retrieves basic personal information about the student.

- **Endpoint:** `/infos/bac/{uuid}/individu`
- **Method:** `GET`
- **Authentication:** Required (Bearer Token)
- **Path Parameters:**
  - `uuid`: UUID from authentication response

#### Response (200 OK)
```json
{
  "dateNaissance": "2001-12-29",
  "id": 37411239,
  "lieuNaissance": "MOHAMADIA",
  "lieuNaissanceArabe": "المحمدية",
  "nomArabe": "بركة",
  "nomLatin": "first name",
  "nss": "",
  "prenomArabe": "arabic name",
  "prenomLatin": "last name"
}
```

#### Response Fields
| Field | Type | Description |
|-------|------|-------------|
| dateNaissance | string | Student's birth date (YYYY-MM-DD) |
| id | number | Individual identifier |
| lieuNaissance | string | Birth place in Latin script |
| lieuNaissanceArabe | string | Birth place in Arabic script |
| nomArabe | string | Last name in Arabic script |
| nomLatin | string | Last name in Latin script |
| nss | string | Social security number (if available) |
| prenomArabe | string | First name in Arabic script |
| prenomLatin | string | First name in Latin script |

### 2. Current Academic Year
Retrieves information about the current academic year.

- **Endpoint:** `/infos/AnneeAcademiqueEncours`
- **Method:** `GET`
- **Authentication:** Required (Bearer Token)

#### Response (200 OK)
```json
{
  "id": 22,
  "code": "2024/2025"
}
```

#### Response Fields
| Field | Type | Description |
|-------|------|-------------|
| id | number | Academic year identifier (used in other API calls) |
| code | string | Human-readable academic year representation |

### 3. Detailed Student Information
Retrieves detailed information about the student for a specific academic year.

- **Endpoint:** `/infos/bac/{uuid}/anneeAcademique/{id}/dia`
- **Method:** `GET`
- **Authentication:** Required (Bearer Token)
- **Path Parameters:**
  - `uuid`: UUID from authentication response
  - `id`: Academic year ID from Current Academic Year endpoint

#### Response (200 OK)
```json
{
  "anneeAcademiqueCode": "2024/2025",
  "anneeAcademiqueId": 22,
  "id": 13243010,
  "individuNomArabe": "arabiv name",
  "individuNomLatin": "latine name",
  "individuPrenomArabe": "arabic last name",
  "individuPrenomLatin": "latin last name",
  "niveauId": 13,
  "niveauLibelleLongAr": "ماستر سنة ثانية",
  "niveauLibelleLongLt": "Master 2",
  "numeroInscription": "UN29012024202038045295",
  "ouvertureOffreFormationId": 79464,
  "photo": "2020/100011083021220000_PH_IMP.JPG",
  "refLibelleCycle": "master",
  "refLibelleCycleAr": "الماستر",
  "situationId": 26,
  "transportPaye": true
}
```

#### Response Fields
| Field | Type | Description |
|-------|------|-------------|
| anneeAcademiqueCode | string | Academic year code (e.g., "2024/2025") |
| anneeAcademiqueId | number | Academic year identifier |
| id | number | Record identifier |
| individuNomArabe | string | Last name in Arabic script |
| individuNomLatin | string | Last name in Latin script |
| individuPrenomArabe | string | First name in Arabic script |
| individuPrenomLatin | string | First name in Latin script |
| niveauId | number | Educational level identifier |
| niveauLibelleLongAr | string | Educational level description in Arabic |
| niveauLibelleLongLt | string | Educational level description in Latin script |
| numeroInscription | string | Registration number |
| ouvertureOffreFormationId | number | Educational offering identifier |
| photo | string | Photo file path |
| refLibelleCycle | string | Educational cycle description |
| refLibelleCycleAr | string | Educational cycle description in Arabic |
| situationId | number | Student situation identifier |
| transportPaye | boolean | Whether transport fees are paid |

### 4. Student Profile Image
Retrieves the student's profile image.

- **Endpoint:** `/infos/image/{uuid}`
- **Method:** `GET`
- **Authentication:** Required (Bearer Token)
- **Path Parameters:**
  - `uuid`: UUID from authentication response

#### Response (200 OK)
- **Content-Type:** `application/json`
- **Body:** Base64-encoded image string that can be decoded to display the student's photo

### 5. Institution Logo
Retrieves the logo of the student's institution.

- **Endpoint:** `/infos/logoEtablissement/{etablissementId}`
- **Method:** `GET`
- **Authentication:** Required (Bearer Token)
- **Path Parameters:**
  - `etablissementId`: Institution ID from authentication response

#### Response (200 OK)
- **Content-Type:** `application/json`
- **Body:** Base64-encoded image string that can be decoded to display the institution's logo

### 6. Academic Periods
Retrieves information about academic periods (semesters) for a specific educational level.

- **Endpoint:** `/infos/niveau/{niveauId}/periodes`
- **Method:** `GET`
- **Authentication:** Required (Bearer Token)
- **Path Parameters:**
  - `niveauId`: Educational level ID from Detailed Student Information response

#### Response (200 OK)
```json
[
    {
        "code": "S1",
        "id": 10,
        "libelleLongAr": "السداسي الأول",
        "libelleLongArCycle": "الليسانس",
        "libelleLongArNiveau": "ليسانس سنة اولى",
        "libelleLongFrCycle": "licence",
        "libelleLongFrNiveau": "Licence 1ère Année",
        "libelleLongLt": "Semestre 1",
        "rang": 1
    },
    {
        "code": "S2",
        "id": 11,
        "libelleLongAr": "السداسي الثاني",
        "libelleLongArCycle": "الليسانس",
        "libelleLongArNiveau": "ليسانس سنة اولى",
        "libelleLongFrCycle": "licence",
        "libelleLongFrNiveau": "Licence 1ère Année",
        "libelleLongLt": "Semestre 2",
        "rang": 2
    }
]
```

#### Response Fields
| Field | Type | Description |
|-------|------|-------------|
| code | string | Period code (e.g., "S1" for Semester 1) |
| id | number | Period identifier |
| libelleLongAr | string | Period name in Arabic |
| libelleLongArCycle | string | Educational cycle in Arabic |
| libelleLongArNiveau | string | Educational level in Arabic |
| libelleLongFrCycle | string | Educational cycle in French |
| libelleLongFrNiveau | string | Educational level in French |
| libelleLongLt | string | Period name in Latin script |
| rang | number | Period order/sequence number |

## Implementation Guidelines

### Authentication Flow
1. Obtain JWT token via login endpoint
2. Store token securely in app storage
3. Include token in all subsequent API requests as Bearer token:
   ```
   authorization: <JWT token from the login response>
   ```
4. Handle token expiration by checking expiration date or handling 401 responses

### Error Handling
Implement comprehensive error handling for these common scenarios:
- Network connectivity issues
- Authentication failures (401)
- Resource not found (404)
- Server errors (500)
- Timeout handling

### API Response Caching
- Cache non-volatile information to reduce API calls
- Implement TTL (Time-To-Live) for cached data
- Provide refresh mechanism for user-initiated updates

### Security Considerations
- Use HTTPS for all API communications
- Never store raw passwords
- Implement proper token storage using secure storage solutions
- Clear sensitive data on logout

## Data Flow Diagram

```
┌─────────────┐       ┌─────────────┐       ┌─────────────┐
│             │       │             │       │             │
│  Login with │       │  Retrieve   │       │  Get Student│
│  Credentials│──────▶│Current Year │──────▶│  Details    │
│             │       │             │       │             │
└─────────────┘       └─────────────┘       └─────────────┘
                                                   │
                                                   ▼
                                            ┌─────────────┐
                                            │             │
                                            │  Get Profile│
                                            │  Image      │
                                            │             │
                                            └─────────────┘
                                                   │
                                                   ▼
                                            ┌─────────────┐       ┌─────────────┐
                                            │             │       │             │
                                            │  Get Inst.  │       │  Get Academic│
                                            │  Logo       │──────▶│  Periods    │
                                            │             │       │             │
                                            └─────────────┘       └─────────────┘
```

## API Testing
- Use Postman or similar tools for API testing
- Test with valid and invalid credentials
- Verify proper error handling
- Check response formats and data validity

## API Versioning
Current API version: v1
Future versions should follow the pattern: `/api/vX/` where X is the version number