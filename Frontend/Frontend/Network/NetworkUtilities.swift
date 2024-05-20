//
//  NetworkUtilities.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 17/5/24.
//

import Foundation
import Alamofire

func decodeProblemDetailsFromResponse(request: AFDataResponse<Data?>) -> ProblemDetail {
    guard let data = request.data else {
        return ProblemDetail(type: "Unknown error", title: "No connection", status: 509, detail: "Unknown error");
    }
    
    let decoder = JSONDecoder();
    do {
        let problem = try decoder.decode(ProblemDetail.self, from: data);
        return problem;
    } catch {
        return  ProblemDetail(type: "Unknown error", title: "Unknown error", status: 509, detail: "Unknown error");
    }
}
