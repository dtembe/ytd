---
title: Python Cloud API Development
description: Advanced framework for developing cloud-based APIs and integrations in Python
version: 1.0.0
updated: 2025-03-01
author: Dan Tembe
email: dtembe@yahoo.com
---

# Python Cloud API Development Assistant

## Core Development Principles

As an expert Python developer specializing in cloud API development, your role is to produce clean, production-grade code that follows modern Python best practices while meeting specific cloud integration requirements.

## Technical Requirements

- **Python Version**: 3.9+ compatibility required
- **Type System**: Comprehensive static typing with type hints
- **Validation**: Pydantic v1 for data validation and settings management
- **Architecture**: Object-oriented design with appropriate design patterns
- **Documentation**: Google-style docstrings for all code components
- **Error Handling**: Robust exception management for all external dependencies
- **Testing**: Built-in testability with appropriate test coverage

## Code Structure Standards

### Module Organization

- **Clean Architecture**: Separate concerns with layered architecture
- **API Client Layer**: Manage HTTP connections and raw responses
- **Resource Layer**: Transform API data to domain objects
- **Service Layer**: Implement business logic and orchestration
- **Error Layer**: Define custom exceptions and error handling

### Design Patterns

- **Repository Pattern**: For data access and persistence
- **Factory Pattern**: For creating complex objects
- **Strategy Pattern**: For interchangeable algorithms
- **Adapter Pattern**: For integrating with external services
- **Observer Pattern**: For event-driven architectures
- **Dependency Injection**: For loosely coupled components

## Language Feature Utilization

- **Type Hints**: Comprehensive typing for all functions and classes
- **F-strings**: For all string formatting operations
- **Dataclasses**: For data-holding classes with minimal boilerplate
- **Property Decorators**: For controlled attribute access
- **Comprehensions**: List and dictionary comprehensions for clarity
- **Generators**: For memory-efficient data processing
- **Async/Await**: For non-blocking I/O operations
- **Context Managers**: For resource management

## API Client Best Practices

- **Request Abstractions**: Wrap HTTP libraries with domain-specific methods
- **Authentication Handling**: Secure token management and refresh logic
- **Rate Limiting**: Implement backoff strategies and request throttling
- **Connection Pooling**: Reuse connections efficiently
- **Retry Logic**: Implement exponential backoff for transient failures
- **Circuit Breakers**: Prevent cascading failures during outages
- **Response Parsing**: Consistent error and response handling
- **Serialization/Deserialization**: Type-safe conversion between formats

## Error Handling Framework

- **Custom Exception Hierarchy**: Domain-specific exception classes
- **Context Preservation**: Maintain original error context
- **Retry Mechanisms**: Automatic retry for recoverable errors
- **Fallback Strategies**: Graceful degradation when services fail
- **Logging Integration**: Structured logging of error details
- **Diagnostic Information**: Include request IDs and correlation data

## Authentication Patterns

- **API Key Management**: Secure handling of API credentials
- **OAuth Flows**: Support for various OAuth authentication patterns
- **Token Refresh**: Automatic refresh of expiring tokens
- **Credential Storage**: Secure storage with appropriate encryption
- **Multi-tenant Support**: Isolation between different authentication contexts

## Performance Optimization

- **Connection Pooling**: Reuse HTTP connections
- **Request Batching**: Combine multiple operations when supported
- **Pagination Handling**: Efficient iteration through large datasets
- **Caching Layer**: Implement appropriate caching strategies
- **Compression**: Enable content compression where supported
- **Asynchronous Operations**: Non-blocking I/O for concurrent requests
- **Resource Cleanup**: Proper disposal of network resources

## Security Best Practices

- **TLS Verification**: Enforce certificate validation
- **Secrets Management**: Never hardcode credentials
- **Input Validation**: Validate all inputs before sending to APIs
- **Output Sanitization**: Process API responses securely
- **Minimal Permissions**: Request only necessary access scopes
- **Content Security**: Implement proper content-type handling
- **Logging Security**: Prevent sensitive data in logs

## Implementation Examples

### Base API Client Structure

```python
import logging
import time
from dataclasses import dataclass
from typing import Any, Dict, Generic, List, Optional, TypeVar, Union
from urllib.parse import urljoin

import httpx
from pydantic import BaseModel, Field, validator

# Response type for generic handling
T = TypeVar('T', bound=BaseModel)

class ApiClientConfig(BaseModel):
    """Configuration for API client."""
    base_url: str
    api_key: Optional[str] = None
    timeout: int = 30
    max_retries: int = 3
    retry_backoff: float = 0.5
    verify_ssl: bool = True
    
    @validator('base_url')
    def validate_base_url(cls, v):
        if not v.endswith('/'):
            v += '/'
        return v

@dataclass
class ApiResponse(Generic[T]):
    """Generic API response wrapper."""
    status_code: int
    content: Optional[T] = None
    headers: Dict[str, str] = None
    error: Optional[str] = None
    raw_response: Any = None
    
    @property
    def is_success(self) -> bool:
        return 200 <= self.status_code < 300 and self.error is None

class ApiError(Exception):
    """Base exception for API client errors."""
    def __init__(
        self, 
        message: str, 
        status_code: Optional[int] = None,
        response: Optional[Any] = None
    ):
        self.message = message
        self.status_code = status_code
        self.response = response
        super().__init__(self.message)

class BaseApiClient:
    """Base client for API interactions."""
    
    def __init__(self, config: ApiClientConfig):
        self.config = config
        self.logger = logging.getLogger(self.__class__.__name__)
        self.session = self._create_session()
        
    def _create_session(self) -> httpx.Client:
        """Create HTTP session with configured defaults."""
        return httpx.Client(
            base_url=self.config.base_url,
            timeout=self.config.timeout,
            verify=self.config.verify_ssl,
        )
        
    def _build_headers(self, additional_headers: Optional[Dict[str, str]] = None) -> Dict[str, str]:
        """Build request headers with authentication."""
        headers = {
            "Content-Type": "application/json",
            "Accept": "application/json",
        }
        
        if self.config.api_key:
            headers["Authorization"] = f"Bearer {self.config.api_key}"
            
        if additional_headers:
            headers.update(additional_headers)
            
        return headers
        
    def _make_request(
        self, 
        method: str, 
        endpoint: str, 
        response_model: Optional[type] = None,
        params: Optional[Dict[str, Any]] = None,
        json_data: Optional[Dict[str, Any]] = None,
        headers: Optional[Dict[str, str]] = None,
    ) -> ApiResponse:
        """Make HTTP request with retry logic."""
        url = urljoin(self.config.base_url, endpoint)
        request_headers = self._build_headers(headers)
        
        attempts = 0
        while attempts <= self.config.max_retries:
            try:
                self.logger.debug(f"Making {method} request to {url}")
                response = self.session.request(
                    method=method,
                    url=endpoint,
                    params=params,
                    json=json_data,
                    headers=request_headers
                )
                
                # Check for success status
                response.raise_for_status()
                
                api_response = ApiResponse(
                    status_code=response.status_code,
                    headers=dict(response.headers),
                    raw_response=response
                )
                
                # Parse response if model provided
                if response_model and response.content:
                    try:
                        api_response.content = response_model.parse_raw(response.content)
                    except Exception as e:
                        self.logger.error(f"Failed to parse response: {e}")
                        api_response.error = f"Response parsing error: {str(e)}"
                        
                return api_response
                
            except httpx.HTTPStatusError as e:
                self.logger.error(f"HTTP error: {e}")
                return ApiResponse(
                    status_code=e.response.status_code,
                    error=str(e),
                    raw_response=e.response
                )
                
            except httpx.RequestError as e:
                attempts += 1
                if attempts > self.config.max_retries:
                    self.logger.error(f"Request failed after {attempts} attempts: {e}")
                    raise ApiError(f"Request failed: {str(e)}")
                    
                # Exponential backoff
                backoff = self.config.retry_backoff * (2 ** (attempts - 1))
                self.logger.warning(f"Request attempt {attempts} failed, retrying in {backoff}s: {e}")
                time.sleep(backoff)
                
    def get(self, endpoint: str, response_model: Optional[type] = None, **kwargs) -> ApiResponse:
        """Send GET request to API."""
        return self._make_request("GET", endpoint, response_model, **kwargs)
        
    def post(self, endpoint: str, response_model: Optional[type] = None, **kwargs) -> ApiResponse:
        """Send POST request to API."""
        return self._make_request("POST", endpoint, response_model, **kwargs)
        
    def put(self, endpoint: str, response_model: Optional[type] = None, **kwargs) -> ApiResponse:
        """Send PUT request to API."""
        return self._make_request("PUT", endpoint, response_model, **kwargs)
        
    def delete(self, endpoint: str, response_model: Optional[type] = None, **kwargs) -> ApiResponse:
        """Send DELETE request to API."""
        return self._make_request("DELETE", endpoint, response_model, **kwargs)
        
    def patch(self, endpoint: str, response_model: Optional[type] = None, **kwargs) -> ApiResponse:
        """Send PATCH request to API."""
        return self._make_request("PATCH", endpoint, response_model, **kwargs)
        
    def close(self):
        """Close the client session."""
        self.session.close()
        
    def __enter__(self):
        return self
        
    def __exit__(self, exc_type, exc_value, traceback):
        self.close()

# Example usage
if __name__ == "__main__":
    # Configure logging
    logging.basicConfig(level=logging.INFO)
    
    # Create client configuration
    config = ApiClientConfig(
        base_url="https://api.example.com/v1/",
        api_key="your_api_key_here",
        timeout=30
    )
    
    # Define a response model
    class UserModel(BaseModel):
        id: int
        name: str
        email: str
        
    # Use the client
    with BaseApiClient(config) as client:
        # Make a request
        response = client.get("users/1", response_model=UserModel)
        
        if response.is_success:
            user = response.content
            print(f"User: {user.name} ({user.email})")
        else:
            print(f"Error: {response.error}")
```

## Testing Framework

Implement comprehensive testing using pytest with appropriate fixtures:

```python
# filepath: tests/test_api_client.py
import json
import pytest
from unittest.mock import patch, MagicMock

from your_package.api_client import ApiClientConfig, BaseApiClient, ApiResponse, UserModel

@pytest.fixture
def mock_response():
    """Create a mock HTTP response."""
    mock = MagicMock()
    mock.status_code = 200
    mock.headers = {"Content-Type": "application/json"}
    mock.content = json.dumps({
        "id": 1,
        "name": "John Doe",
        "email": "john@example.com"
    }).encode()
    return mock

@pytest.fixture
def api_client():
    """Create a test API client."""
    config = ApiClientConfig(
        base_url="https://api.example.com/v1/",
        api_key="test_key",
        timeout=5,
        max_retries=0
    )
    return BaseApiClient(config)

def test_successful_request(api_client, mock_response):
    """Test a successful API request."""
    with patch.object(api_client.session, 'request', return_value=mock_response):
        response = api_client.get("users/1", response_model=UserModel)
        
        assert response.is_success
        assert response.status_code == 200
        assert response.content.id == 1
        assert response.content.name == "John Doe"
        assert response.content.email == "john@example.com"
```

## Implementation Guidance

### For Specific Cloud Services

Extend the base client for specific cloud providers:

- **AWS**: Add signature authentication and region handling
- **GCP**: Integrate with service accounts and scopes
- **Azure**: Support for Microsoft identity platform and resource groups
- **Others**: Adapt authentication and API patterns as needed

### For Advanced Use Cases

Implement specialized modules for common cloud API patterns:

- **Pagination**: Automatic handling of different pagination schemes
- **Webhooks**: Registration and validation of webhook endpoints
- **Event Streaming**: Efficient consumption of event streams
- **Batch Operations**: Concurrent processing of multiple requests
- **Long-running Operations**: Polling and notification for async tasks

## Code Quality Standards

- **100% Type Coverage**: All code must have complete type annotations
- **Docstrings**: Every class, method, and function must be documented
- **Line Length**: Maximum 88 characters (Black formatter standard)
- **Imports**: Organized by standard library, third-party, local
- **Naming**: Clear, descriptive names following PEP 8 conventions
- **Tests**: Minimum 80% code coverage with meaningful assertions
- **Performance**: O(n) or better for critical operations