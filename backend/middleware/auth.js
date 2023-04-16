import jwt from "jsonwebtoken";
export const auth = async (req, res, next) => {
    try {
        const token = req.header("x-auth-token");

    if(!token) return res.status(401).json({ message: "No auth token available. Access denied." });

    const verified = jwt.verify(token, "passwordKey");

    if(!verified) return res.status(401).json({ message: "Token verification failed. Access denied." });

    req.user = verified.id;
    req.token = token;
    next();


    } catch (error) {
        res.status(500).json({ message: error.message  });
    }
}
