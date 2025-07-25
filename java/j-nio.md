### Do applications usually work directly with Java NIO or through libraries?
It depends on application needs.

#### 1. Direct NIO Usage
- When: For low-level, fine-tuned control over performance-critical I/O (such as building your own protocol servers, file operations in utilities, custom network daemons, etc.).
- Examples: High-performance web servers (like Netty’s core), custom file processing tools, learning/demo projects.
- Pros: Maximum control, possibly best performance, no dependencies.
- Cons: More boilerplate, steeper learning curve, more code to maintain (especially for error handling, protocol support, etc.).

#### 2. Using Higher-Level Libraries (Common in Practice)
- When: For most real-world, production applications or when you need protocol support (HTTP, FTP, WebSockets, etc.), robustness, and extra features.
- Libraries:  
 - Netty - Extremely widely used for building scalable network applications (servers, proxies, etc.), wraps NIO and adds lots of conveniences.
 - Apache MINA - Network application framework on top of NIO.
 - Grizzly - Networking framework (used in GlassFish).
 - Akka - Actor model; Akka HTTP leverages NIO under the hood.
 - Spring WebFlux - Reactive web framework built on top of NIO (using Reactor Netty/Undertow).
 - Ktor (Kotlin) - Runs on Netty, Vert.x, and more.
For file I/O, developers often use the easier, higher-level APIs in java.nio.file.Files, which themselves internally leverage NIO. For almost all networking, teams use libraries that wrap NIO so they don't have to reinvent concurrency, buffer pooling, protocol parsing, etc.

---
## Summary Table
| Use NIO Directly        | Use Libraries                           |
|------------------------|-----------------------------------------|
| Custom tools/utilities  | Most production-grade apps/servers      |
| Learning or research   | Web servers, app backends, protocol impls |
| Performance tuning     | Protocol-level features (HTTP, SSL, etc) |
| Fine-grained control   | Scalability, less boilerplate, features  |
---
### In Practice
- Most apps use high-level libraries that themselves are built on top of NIO for networking or advanced I/O.
- Only use raw NIO for custom platforms/tools or if you need full control and have the resources to maintain and test it thoroughly.
---
If you're starting out and building anything production-oriented, prefer a library like Netty or what your framework provides. If you're learning or writing a one-off tool, working directly with NIO is worthwhile.