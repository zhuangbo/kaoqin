package kaoqin

import java.net.URL

import org.springframework.security.authentication.AuthenticationServiceException
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.authentication.dao.AbstractUserDetailsAuthenticationProvider
import org.springframework.security.authentication.dao.DaoAuthenticationProvider
import org.springframework.security.core.Authentication
import org.springframework.security.core.AuthenticationException
import org.springframework.security.core.userdetails.UserDetails


/**
 * 实现基于DAO和Web门户的用户验证。
 * 如果通过DAO方式验证失败后，继续尝试利用Web门户进行验证。
 * 
 * @author 庄波
 *
 */
class DaoAndWebPortalAuthenticationProvider extends AbstractUserDetailsAuthenticationProvider {
	
	private static final String LOGIN_URL = "http://portal.bzu.edu.cn/loginAction.do?userName=%s&userPass=%s";
	private static final String LOGIN_SUCCESS = "<script>window.top.location.href=\"/index_jg.jsp\"</script>";
		
	DaoAuthenticationProvider daoAuthenticationProvider  // 注入 daoAuthenticationProvider

	/**
	 * 如果通过DAO方式验证失败后，继续尝试利用Web门户进行验证。
	 */
	@Override
	protected void additionalAuthenticationChecks(UserDetails userDetails,
			UsernamePasswordAuthenticationToken authentication)
			throws AuthenticationException {
		try {
			// 尝试 DAO 方式验证密码
			daoAuthenticationProvider.additionalAuthenticationChecks(userDetails, authentication)
		} catch (AuthenticationException authEx) {
			// 正常的DAO方式验证密码失败
			try {
				// 尝试登录门户网站验证密码
				if(new URL(String.format(LOGIN_URL, authentication.principal, authentication.credentials)).text.indexOf(LOGIN_SUCCESS) != -1) {
					// 门户网站登录成功，将正确的密码保存到数据库中（以后可以仅用DAO方式验证即可）
					User.withTransaction { status ->
						User user = User.findByUsername(userDetails.username)
						user.password = authentication.credentials.toString()
						user.save()
					}
					// 重新加载用户信息（缓存后可以进一步省去以后从数据库中加载）
					userDetails = retrieveUser(userDetails.username, authentication)
				} else {
					// 门户网站登录失败，验证失败
					throw authEx;
				}
			} catch (IOException networkEx) {
				// 网络故障，无法访问门户网站
				throw new AuthenticationServiceException(messages.getMessage("daoAndWebPortalAuthenticationProvider.service.unavailable"))
			}
		}
	}

	@Override
	protected UserDetails retrieveUser(String username,
			UsernamePasswordAuthenticationToken authentication)
			throws AuthenticationException {
		return daoAuthenticationProvider.retrieveUser(username, authentication);
	}
}